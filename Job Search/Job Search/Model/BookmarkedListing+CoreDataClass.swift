//
//  BookmarkedListing+CoreDataClass.swift
//  Job Search
//
//  Created by Jonathon James on 12/08/2021.
//
//

import Foundation
import CoreData

/// Describes a job listing which has been bookmarked.
@objc(BookmarkedListing)
public class BookmarkedListing: NSManagedObject {
    
    @NSManaged public var id: Int64

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedListing> {
        return NSFetchRequest<BookmarkedListing>(entityName: "BookmarkedListing")
    }
}

// MARK: Identifiable conformance

extension BookmarkedListing : Identifiable {}
