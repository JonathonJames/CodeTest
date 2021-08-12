//
//  JobListing.swift
//  Job Search
//
//  Created by Uncreation on 12/08/2021.
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
    let minimumSalary: Double? // TODO: This is currency the API sends as a floating-point value. This is open to loss of precision.
    let maximumSalary: Double? // TODO: This is currency the API sends as a floating-point value. This is open to loss of precision.
    let currency: String?
    let expirationDate: Date
    let date: Date
    let jobDescription: String
    let applications: Int
    let jobUrl: String
}
