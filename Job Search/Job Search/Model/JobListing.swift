//
//  JobListing.swift
//  Job Search
//
//  Created by Jonathon James on 12/08/2021.
//

import Foundation

/// Describes a job listing as defined at https://www.reed.co.uk/developers/jobseeker (12/08/2021)
struct JobListing: Decodable {
    let jobId: Int64
    let employerId: Int64
    let employerName: String
    let employerProfileId: Int64?
    let employerProfileName: String?
    let jobTitle: String
    let locationName: String
    let minimumSalary: Double?
    let maximumSalary: Double?
    let currency: String?
    let expirationDate: Date
    let date: Date
    let jobDescription: String
    let applications: Int64
    let jobUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case jobId
        case employerId
        case employerName
        case employerProfileId
        case employerProfileName
        case jobTitle
        case locationName
        case minimumSalary
        case maximumSalary
        case currency
        case expirationDate
        case date
        case jobDescription
        case applications
        case jobUrl
    }
    
    
    init(from decoder: Decoder) throws {
        
        // Custom decoding. Although the large majority of this is the same as the default implementation,
        // this allows for dates/floating-point-to-Decimal to be handled internally. This is important for re-use
        // as if this struct is nested within a parent object, the default JSONDecoder can only handle the 1 date
        // strategy, etc. Keeping things internal means the caller doesn't need to care about these kinds of details.
        
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.jobId = try container.decode(Int64.self, forKey: .jobId)
        self.employerId = try container.decode(Int64.self, forKey: .employerId)
        self.employerName = try container.decode(String.self, forKey: .employerName)
        self.employerProfileId = try container.decodeIfPresent(Int64.self, forKey: .employerProfileId)
        self.employerProfileName = try container.decodeIfPresent(String.self, forKey: .employerProfileName)
        self.jobTitle = try container.decode(String.self, forKey: .jobTitle)
        self.locationName = try container.decode(String.self, forKey: .locationName)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.jobDescription = try container.decode(String.self, forKey: .jobDescription)
        self.applications = try container.decode(Int64.self, forKey: .applications)
        self.jobUrl = try container.decode(String.self, forKey: .jobUrl)
        
        #warning("TODO: These salary values the API sends are floating-point. This is open to loss of precision.")
        self.minimumSalary = try container.decodeIfPresent(Double.self, forKey: .minimumSalary)
        self.maximumSalary = try container.decodeIfPresent(Double.self, forKey: .maximumSalary)
        
        guard let expirationDate: Date = JobListing.dateFormatter.date(from: try container.decode(String.self, forKey: .expirationDate)) else {
            throw DecodingError.dataCorruptedError(forKey: .expirationDate, in: container, debugDescription: "Invalid expiration date")
        }
        self.expirationDate = expirationDate
        
        guard let date: Date = JobListing.dateFormatter.date(from: try container.decode(String.self, forKey: .date)) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date")
        }
        self.date = date
    }
    
    /// A formatter setup for converting "DD/MM/YYYY" values into `Date`s during the decoding process.
    private static var dateFormatter: DateFormatter = {
        let retval: DateFormatter = .init()
        retval.dateFormat = "DD/MM/YYYY"
        return retval
    }()
}


extension JobListing: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.jobId)
    }
}
