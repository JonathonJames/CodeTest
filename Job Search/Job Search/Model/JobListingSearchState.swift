//
//  JobListingSearchState.swift
//  Job Search
//
//  Created by Jonathon James on 12/08/2021.
//

import UIKit.UIApplication

/// Describes the state of a `JobListingSearchViewController`
enum JobListingSearchState {
    
    /// Section descriptors by which `JobListing`s can be segregated.
    enum DataSections: Int, CaseIterable {
        case bookmarked = 0
        case other = 1
    }
    
    /// Describes, sectioned and formatted JobListings.
    final class ListingData {
        let pageSize: Int64
        let currentPage: Int64
        let listingsTotal: Int64
        let data: [DataSections : [JobListing]]
        
        init(result: JobListingSearchResult) {
            self.pageSize = result.query.resultsToTake ?? 100
            self.currentPage = (result.query.resultsToSkip ?? 0) / self.pageSize
            self.listingsTotal = result.response.totalResults
            
            // Filter the results into sections based on whether the listing is bookmarked.
            
            let bookmarked: [BookmarkedListing]
            if let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
               bookmarked = try! delegate.persistentContainer.viewContext.fetch(BookmarkedListing.fetchRequest())
            } else {
                bookmarked = []
            }
            
            if bookmarked.isEmpty {
                self.data = [.other : result.response.results]
            } else {
                var favorites: [JobListing] = []
                var other: [JobListing] = result.response.results
                
                while let index = other.firstIndex(where: { listing in
                    bookmarked.contains { favorite in
                        favorite.id == listing.jobId
                    }
                }) {
                    favorites.append(other.remove(at: index))
                }
                
                self.data = [
                    .bookmarked : favorites,
                    .other : other
                ]
            }
        }
    }
    
    case idle
    case loading
    case error(Error)
    case loaded(ListingData)
}

extension JobListingSearchState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsData), .loaded(let rhsData)):
            return lhsData === rhsData
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
