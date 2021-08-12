//
//  JobListingSearchViewController.swift
//  Job Search
//
//  Created by Jonathon James on 11/08/2021.
//

import UIKit
import Combine

/// Describes a cell which displays a preview for a job listing.
final class JobListingTableViewCell: UITableViewCell {

    @IBOutlet private var jobTitleLabel: UILabel!

    func bind(to viewModel: JobListing) {
        self.jobTitleLabel.text = viewModel.jobTitle
        self.jobTitleLabel.sizeToFit()
    }
}

/// A wrapper around all the input parameters required to construct a query.
private struct InputParameters {
    // Publishes keyword search parameters.
    let keyword: AnyPublisher<String, Never>
    
    #warning("TODO: Add other filter parameters")
}



/// Describes a view controller which allows for the search and display of `JobListing`s.
final class JobListingSearchViewController: UIViewController {
    
    final class ViewModel {
        fileprivate let repository: JobSearchRepository
        fileprivate var query: JobSearchQuery = .init()
        private var cancellables: [AnyCancellable] = []
        
        init(repository: JobSearchRepository) {
            self.repository = repository
        }
        
        fileprivate func process(input: InputParameters) -> AnyPublisher<JobListingSearchState, Never> {
            
            self.cancellables.forEach { $0.cancel() }
            self.cancellables.removeAll()

            let keywordInput = input.keyword
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
                .filter({ !$0.isEmpty })
            
            let asyncSearch = keywordInput
                .flatMap({ [unowned self] keywords in self.repository.performSearch(self.query.withKeywordSearch(keywords)) })
                .map { result -> JobListingSearchState in
                    switch result {
                    case .success(let searchResults):
                        return .loaded(.init(result: searchResults))
                    case .failure(let error):
                        return .error(error)
                    }
                }
                .eraseToAnyPublisher()


            let initialState: AnyPublisher<JobListingSearchState, Never> = Just(.idle).eraseToAnyPublisher()
            let emptySearchString: AnyPublisher<JobListingSearchState, Never> = keywordInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
            let idle: AnyPublisher<JobListingSearchState, Never> = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

            return Publishers.Merge(idle, asyncSearch).removeDuplicates().eraseToAnyPublisher()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let keywordSearchPublisher: PassthroughSubject<String, Never> = .init()
    
    private var cancellables: [AnyCancellable] = []
    
    let viewModel: ViewModel! = {
        
        let config: URLSessionConfiguration = .ephemeral
        config.httpAdditionalHeaders = ["Authorization" : "Basic YmI2YjM3MTgtOTA2YS00NTJlLWEwMmEtY2RiMjVlNDU2NDIyIDo="]
        
        return .init(
            repository: .init(
                api: JobSearchNetworkingDomain(
                    baseURL: "https://www.reed.co.uk/api/1.0/",
                    session: URLSession(configuration: config)
                )
            )
        )
    }()
    
    var subscriptions: [AnyCancellable] = []
    
    private lazy var datasource: UITableViewDiffableDataSource<JobListingSearchState.DataSections, JobListing> = {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, model in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobListingTableViewCell") as? JobListingTableViewCell else {
                    assertionFailure("Failed to dequeue JobListingTableViewCell")
                    return UITableViewCell()
                }
                #warning("TODO: Setup accessibility identifier")
                cell.bind(to: model)
                return cell
            }
        )
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the table view's datasource and search bar's delegate.

        self.tableView.dataSource = self.datasource
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 42
        
        self.searchBar.delegate = self
        
        /// Bind the publisher(s) to the view.
        
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
        
        let input = InputParameters(keyword: self.keywordSearchPublisher.eraseToAnyPublisher())

        let output = self.viewModel.process(input: input)

        output.sink(receiveValue: {[unowned self] state in
            switch state {
            case .idle:
                #warning("TODO: Prompt the user to do something. Give them an example search query, perhaps.")
                break
            case .loading:
                #warning("TODO: Display a loading indicator.")
                break
            case .error(let error):
                #warning("TODO: Inform the user of the error.")
                print("An error occured when performing search: \(error)")
            case .loaded(let data):
                DispatchQueue.main.async {
                    var snapshot = NSDiffableDataSourceSnapshot<JobListingSearchState.DataSections, JobListing>()
                    snapshot.appendSections(JobListingSearchState.DataSections.allCases)
                    JobListingSearchState.DataSections.allCases.forEach { section in
                        snapshot.appendItems(data.data[section] ?? [], toSection: section)
                    }
                    self.datasource.apply(snapshot, animatingDifferences: true)
                }
            }
        }).store(in: &cancellables)
    }
}

extension JobListingSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keywordSearchPublisher.send(searchText)
    }
}
