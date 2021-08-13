//
//  JobSearchQuery.swift
//  Job Search
//
//  Created by Jonathon James on 11/08/2021.
//

import Foundation

/// A query which can be applied to a job search. Based on API spec defined at https://www.reed.co.uk/developers/jobseeker#search-Parameter (11/08/2021)
struct JobSearchQuery {
    
    /// Describes a set of job type options.
    struct JobTypeOptions: OptionSet {
        let rawValue: Int
        
        /// a permanent role
        static let permanent = JobTypeOptions(rawValue: 1 << 0)
        /// a contract role
        static let contract = JobTypeOptions(rawValue: 1 << 1)
        /// a temp role
        static let temp = JobTypeOptions(rawValue: 1 << 2)
        /// a part-time role
        static let partTime = JobTypeOptions(rawValue: 1 << 3)
        /// a full-time role
        static let fullTime = JobTypeOptions(rawValue: 1 << 4)
        /// a graduate role
        static let graduate = JobTypeOptions(rawValue: 1 << 5)
    }
    
    /// Describes a set of listing type options
    struct ListingTypeOptions: OptionSet {
        let rawValue: Int
        
        /// the listing was posted by an agency
        static let postedByRecruitmentAgency = ListingTypeOptions(rawValue: 1 << 0)
        /// the listing was posted by the employer
        static let postedByDirectEmployer = ListingTypeOptions(rawValue: 1 << 1)
    }
    
    /// id of employer posting job
    var employerId: String?
    /// profile id of employer posting job
    var employerProfileId: String?
    /// any search keywords
    var keywords: String?
    /// the location of the job
    var locationName: String?
    /// distance from location name in miles (default is 10)
    var distanceFromLocation: Int64?
    /// types of jobs to include
    var typeOptions: JobTypeOptions
    /// lowest possible salary e.g. 20000
    var minimumSalary: Double?
    /// highest possible salary e.g. 30000
    var maximumSalary: Double?
    /// types of listing to include
    var listingOptions: ListingTypeOptions
    /// maximum number of results to return (defaults and is limited to 100 results)
    var resultsToTake: Int64?
    /// number of results to skip (this can be used with resultsToTake for paging)
    var resultsToSkip: Int64?
    
    
    /// Convenience init with default parameters
    init() {
        self.typeOptions = []
        self.listingOptions = []
    }
}


// MARK: URLQueryConvertible Conformance

extension JobSearchQuery.ListingTypeOptions: URLQueryConvertible {
    
    func convertToURLQueryItems() -> [URLQueryItem] {

        var retval: [URLQueryItem] = []
        
        if self.contains(.postedByRecruitmentAgency) {
            retval.append(.init(name: "postedByRecruitmentAgency", value: "true"))
        }
        
        if self.contains(.postedByDirectEmployer) {
            retval.append(.init(name: "postedByDirectEmployer", value: "true"))
        }

        return retval
    }
}

extension JobSearchQuery.JobTypeOptions: URLQueryConvertible {
    
    func convertToURLQueryItems() -> [URLQueryItem] {

        var retval: [URLQueryItem] = []
        
        if self.contains(.permanent) {
            retval.append(.init(name: "permanent", value: "true"))
        }
        
        if self.contains(.contract) {
            retval.append(.init(name: "contract", value: "true"))
        }
        
        if self.contains(.temp) {
            retval.append(.init(name: "temp", value: "true"))
        }
        
        if self.contains(.partTime) {
            retval.append(.init(name: "partTime", value: "true"))
        }
        
        if self.contains(.fullTime) {
            retval.append(.init(name: "fullTime", value: "true"))
        }
        
        if self.contains(.graduate) {
            retval.append(.init(name: "graduate", value: "true"))
        }

        return retval
    }
}

extension JobSearchQuery: URLQueryConvertible {
    
    func convertToURLQueryItems() -> [URLQueryItem] {
        
        var retval: [URLQueryItem] = []
        
        if let employerId: String = self.employerId {
            retval.append(.init(name: "employerId", value: employerId))
        }

        if let employerProfileId: String = self.employerProfileId {
            retval.append(.init(name: "employerProfileId", value: employerProfileId))
        }
       
        if let keywords: String = self.keywords {
            retval.append(.init(name: "keywords", value: keywords))
        }
        
        if let locationName: String = self.locationName {
            retval.append(.init(name: "locationName", value: locationName))
        }
        
        if let distanceFromLocation: Int64 = self.distanceFromLocation {
            retval.append(.init(name: "distanceFromLocation", value: "\(distanceFromLocation)"))
        }
        
        retval.append(contentsOf: self.typeOptions.convertToURLQueryItems())
        
        if let minimumSalary: Double = self.minimumSalary {
            retval.append(.init(name: "minimumSalary", value: String(format: "%.0f", minimumSalary)))
        }
        
        if let maximumSalary: Double = self.maximumSalary {
            retval.append(.init(name: "maximumSalary", value:  String(format: "%.0f", maximumSalary)))
        }

        retval.append(contentsOf: self.listingOptions.convertToURLQueryItems())
        
        if let resultsToTake: Int64 = self.resultsToTake {
            retval.append(.init(name: "resultsToTake", value: "\(resultsToTake)"))
        }
        
        if let resultsToSkip: Int64 = self.resultsToSkip {
            retval.append(.init(name: "resultsToSkip", value: "\(resultsToSkip)"))
        }
        
        return retval
    }
}
