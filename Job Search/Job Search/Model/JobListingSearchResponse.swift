//
//  JobListingSearchResponse.swift
//  Job Search
//
//  Created by Uncreation on 12/08/2021.
//

import Foundation

/// Describes a job search result as defined at https://www.reed.co.uk/developers/jobseeker (12/08/2021)
struct JobListingSearchResponse: Decodable {
    let results: [JobListing]
    let totalResults: Int64
}

/// Describes a search result (the original query and the response)
struct JobListingSearchResult {
    let query: JobSearchQuery
    let response: JobListingSearchResponse
}
