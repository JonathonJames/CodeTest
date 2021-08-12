//
//  JobDetailsViewController.swift
//  Job Search
//
//  Created by Jonathon James on 12/08/2021.
//

import UIKit


final class JobDetailsViewController: UIViewController {
    
    struct ViewModel {
        let listing: JobListing
    }
    
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var employerHeaderLabel: UILabel!
    @IBOutlet private weak var employerNameLabel: UILabel!
    @IBOutlet private weak var jobTitleHeaderLabel: UILabel!
    @IBOutlet private weak var jobTitleLabel: UILabel!
    @IBOutlet private weak var salaryHeaderLabel: UILabel!
    @IBOutlet private weak var salaryLabel: UILabel!
    
    @IBOutlet private weak var descriptionHeaderLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.employerNameLabel.text = self.viewModel.listing.employerName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.jobTitleLabel.text = self.viewModel.listing.jobTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        self.descriptionLabel.text = self.viewModel.listing.jobDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let currency: String = self.viewModel.listing.currency {
            
            #warning("TODO: Localize these strings")
            
            let formatter: NumberFormatter = .init()
            formatter.currencyCode = currency
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            
            if let min: Double = self.viewModel.listing.minimumSalary {
                if let max: Double = self.viewModel.listing.maximumSalary {
                    if let minText: String = formatter.string(from: NSNumber(value: min)),
                       let maxText: String = formatter.string(from: NSNumber(value: max)) {
                        self.salaryLabel.text = "\(minText) - \(maxText)"
                    } else {
                        self.salaryLabel.text = "Salary unspecified"
                    }
                } else if let minText: String = formatter.string(from: NSNumber(value: min)) {
                    self.salaryLabel.text = "From \(minText)"
                } else {
                    self.salaryLabel.text = "Salary unspecified"
                }
            } else if let max: Double = self.viewModel.listing.maximumSalary,
                      let maxText: String = formatter.string(from: NSNumber(value: max)) {
                self.salaryLabel.text = "Up to \(maxText)"
            } else {
                self.salaryLabel.text = "Salary unspecified"
            }
        }
    }
    
    static func newInstance(viewModel: ViewModel) -> JobDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let instance = storyboard.instantiateViewController(withIdentifier: "JobDetailsViewController") as! JobDetailsViewController
        instance.viewModel = viewModel
        return instance
    }
}
