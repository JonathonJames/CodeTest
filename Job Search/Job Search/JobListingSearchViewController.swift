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
    // Publishes pagination parameters.
    let pagination: AnyPublisher<Int64, Never>
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
            
            let paginationInput = input.pagination
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
            
            let asyncSearch = Publishers.CombineLatest(keywordInput, paginationInput)
                .flatMap({ [unowned self] (keywords, page) -> AnyPublisher<Result<JobListingSearchResult, Error>, Never> in
                    var query = self.query
                    query.keywords = keywords
                    query.resultsToSkip = page * (query.resultsToTake ?? 25)
                    return self.repository.performSearch(query)
                })
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
    private let paginationPublisher: CurrentValueSubject<Int64, Never> = .init(0)
    
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
    
    private lazy var datasource: UITableViewDiffableDataSource<JobListingSearchState.DataSections, JobListing> = {
        let retval: UITableViewDiffableDataSource<JobListingSearchState.DataSections, JobListing> = .init(
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
        
        var snapshot = retval.snapshot()
        snapshot.appendSections(JobListingSearchState.DataSections.allCases)
        retval.apply(snapshot, animatingDifferences: false)
        return retval
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the table view's datasource and search bar's delegate.

        self.tableView.dataSource = self.datasource
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 42
        
        self.searchBar.delegate = self
        
        /// Bind the publisher(s) to the view.
        
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
        
        self.viewModel.process(
            input: InputParameters(
                keyword: self.keywordSearchPublisher.eraseToAnyPublisher(),
                pagination: self.paginationPublisher.eraseToAnyPublisher()
            )
        )
        .sink(receiveValue: {[unowned self] state in
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
                    var snapshot = self.datasource.snapshot()
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

extension JobListingSearchViewController: UITableViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if targetContentOffset.pointee.y >= scrollView.contentSize.height - (scrollView.visibleSize.height * 1.5) {
            #warning("TODO: Only try and paginate if there's more data to fetch")
            self.paginationPublisher.send(self.paginationPublisher.value + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listing: JobListing = self.datasource.itemIdentifier(for: indexPath) else {
            #warning("TODO: Display an error here. The selected listing can't be found.")
            return
        }

        self.navigationController?.pushViewController(
            JobDetailsViewController.newInstance(viewModel: .init(listing: listing)),
            animated: true
        )
    }
}
