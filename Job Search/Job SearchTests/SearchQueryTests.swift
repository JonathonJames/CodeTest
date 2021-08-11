//
//  Job_SearchTests.swift
//  Job SearchTests
//
//  Created by Jonathon James on 11/08/2021.
//

import XCTest
@testable import Job_Search

final class SearchQueryTests: XCTestCase {

    /// Tests that an empty job search query will yield no URLQueryItem values upon conversion.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` is empty
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall be empty.
    func testConvertToURLQuery_empty() throws {
        XCTAssertEqual([], JobSearchQuery().convertToURLQueryItems())
    }
    
    /// Tests that a job search query will yield the appropriate output for its `employerId` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `employerId` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "employerId" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `employerId` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "employerId".
    func testConvertToURLQuery_employerID() throws {
        
        var vut: JobSearchQuery = .init()
        vut.employerId = "12345678"
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "employerId"  && $0.value == "12345678" }))
        
        vut.employerId = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "employerId" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `employerProfileId` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `employerProfileId` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "employerProfileId" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `employerProfileId` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "employerProfileId".
    func testConvertToURLQuery_employerProfileId() throws {
        
        var vut: JobSearchQuery = .init()
        vut.employerProfileId = "12345678"
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "employerProfileId"  && $0.value == "12345678" }))
        
        vut.employerProfileId = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "employerProfileId" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `keywords` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `keywords` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "keywords" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `keywords` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "keywords".
    func testConvertToURLQuery_keywords() throws {
        
        var vut: JobSearchQuery = .init()
        vut.keywords = "iOS Developer"
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "keywords"  && $0.value == "iOS Developer" }))
        
        vut.keywords = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "keywords" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `locationName` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `locationName` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "locationName" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `locationName` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "locationName".
    func testConvertToURLQuery_locationName() throws {
        
        var vut: JobSearchQuery = .init()
        vut.locationName = "London"
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "locationName"  && $0.value == "London" }))
        
        vut.locationName = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "locationName" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `distanceFromLocation` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `distanceFromLocation` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "distanceFromLocation" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `distanceFromLocation` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "distanceFromLocation".
    func testConvertToURLQuery_distanceFromLocation() throws {
        
        var vut: JobSearchQuery = .init()
        vut.distanceFromLocation = 7
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "distanceFromLocation"  && $0.value == "7" }))
        
        vut.distanceFromLocation = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "distanceFromLocation" }))
    }
    
    
    /// Tests that a job search query will yield the appropriate output for its `typeOptions` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` contains a `.contract` value for its `typeOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "contract" and a value of "true"
    ///
    /// Scenario 2:
    /// GIVEN That a `JobSearchQuery` contains a `.permanent` value for its `typeOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "permanent" and a value of "true"
    ///
    /// Scenario 3:
    /// GIVEN That a `JobSearchQuery` contains a `.partTime` value for its `typeOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `partTime` of "partTime" and a value of "true"
    ///
    /// Scenario 4:
    /// GIVEN That a `JobSearchQuery` contains a `.fullTime` value for its `typeOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "fullTime" and a value of "true"
    ///
    /// Scenario 5:
    /// GIVEN That a `JobSearchQuery` contains a `.temp` value for its `typeOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `temp` of "temp" and a value of "true"
    ///
    /// Scenario 6:
    /// GIVEN That a `JobSearchQuery` contains a `.graduate` value for its `typeOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `graduate` of "graduate" and a value of "true"
    ///
    /// Scenario 7:
    /// GIVEN That a `JobSearchQuery` value has its `typeOptions` parameter set to `nil` or `[]`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "contract", "permanent", "partTime", "temp" or "graduate"
    func testConvertToURLQuery_jobType() throws {
        
        var vut: JobSearchQuery = .init()
        vut.typeOptions = .contract
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "contract"  && $0.value == "true" }))
        
        vut.typeOptions = .permanent
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "permanent"  && $0.value == "true" }))
        
        vut.typeOptions = .partTime
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "partTime"  && $0.value == "true" }))
        
        vut.typeOptions = .fullTime
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "fullTime"  && $0.value == "true" }))
        
        vut.typeOptions = .temp
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "temp"  && $0.value == "true" }))
        
        vut.typeOptions = .graduate
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "graduate"  && $0.value == "true" }))

        vut.typeOptions = []
        XCTAssertFalse(vut.convertToURLQueryItems().contains(
            where: {
                $0.name == "contract" ||
                $0.name == "permanent" ||
                $0.name == "partTime" ||
                $0.name == "fullTime" ||
                $0.name == "temp" ||
                $0.name == "graduate"
            }
        ))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `minimumSalary` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `minimumSalary` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "minimumSalary" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `minimumSalary` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "minimumSalary".
    func testConvertToURLQuery_minimumSalary() throws {
        
        var vut: JobSearchQuery = .init()
        vut.minimumSalary = 30000
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "minimumSalary"  && $0.value == "30000" }))
        
        vut.minimumSalary = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "minimumSalary" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `maximumSalary` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `maximumSalary` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "maximumSalary" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `maximumSalary` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "maximumSalary".
    func testConvertToURLQuery_maximumSalary() throws {
        
        var vut: JobSearchQuery = .init()
        vut.maximumSalary = 30000
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "maximumSalary"  && $0.value == "30000" }))
        
        vut.maximumSalary = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "maximumSalary" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `listingOptions` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` contains a `.contract` value for its `listingOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "postedByDirectEmployer" and a value of "true"
    ///
    /// Scenario 2:
    /// GIVEN That a `JobSearchQuery` contains a `.permanent` value for its `listingOptions` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "postedByRecruitmentAgency" and a value of "true"
    ///
    /// Scenario 3:
    /// GIVEN That a `JobSearchQuery` value has its `listingOptions` parameter set to `nil` or `[]`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "postedByDirectEmployer" or "postedByRecruitmentAgency"
    func testConvertToURLQuery_listingType() throws {
        
        var vut: JobSearchQuery = .init()
        vut.listingOptions = .postedByDirectEmployer
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "postedByDirectEmployer"  && $0.value == "true" }))
        
        vut.listingOptions = .postedByRecruitmentAgency
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "postedByRecruitmentAgency"  && $0.value == "true" }))

        vut.listingOptions = []
        XCTAssertFalse(vut.convertToURLQueryItems().contains(
            where: {
                $0.name == "postedByDirectEmployer" ||
                $0.name == "postedByRecruitmentAgency"
            }
        ))
    }


    /// Tests that a job search query will yield the appropriate output for its `resultsToTake` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `resultsToTake` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "resultsToTake" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `resultsToTake` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "resultsToTake".
    func testConvertToURLQuery_resultsToTake() throws {
        
        var vut: JobSearchQuery = .init()
        vut.resultsToTake = 25
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "resultsToTake"  && $0.value == "25" }))
        
        vut.resultsToTake = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "resultsToTake" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for its `resultsToSkip` parameter.
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has a non-nil value for its `resultsToSkip` parameter
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain a `URLQueryItem` with a `name` of "resultsToSkip" and a value equal to the assigned value.
    ///
    /// Scenario 2:
    /// GIVEN That an existing `JobSearchQuery` value has its `resultsToSkip` parameter set to `nil`
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall no longer contain a `URLQueryItem` value with a name of "resultsToSkip".
    func testConvertToURLQuery_resultsToSkip() throws {
        
        var vut: JobSearchQuery = .init()
        vut.resultsToSkip = 25
        XCTAssertTrue(vut.convertToURLQueryItems().contains(where: { $0.name == "resultsToSkip"  && $0.value == "25" }))
        
        vut.resultsToSkip = nil
        XCTAssertFalse(vut.convertToURLQueryItems().contains(where: { $0.name == "resultsToSkip" }))
    }
    
    /// Tests that a job search query will yield the appropriate output for multiple fields
    ///
    /// Scenario 1:
    /// GIVEN That a `JobSearchQuery` has mult9ple non-nil value for its parameters
    /// AND we use the `convertToURLQueryItems` function as provided per URLQueryConvertible conformance
    /// THEN the resulting array shall contain appropriate `URLQueryItem` for each parameter.
    func testConvertToURLQuery_Combined() throws {
        
        var vut: JobSearchQuery = .init()
        var expected: [URLQueryItem] = []
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.employerId = "12345678"
        expected.append(.init(name: "employerId", value: "12345678"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.employerProfileId = "12345678"
        expected.append(.init(name: "employerProfileId", value: "12345678"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.keywords = "iOS Developer"
        expected.append(.init(name: "keywords", value: "iOS Developer"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.locationName = "London"
        expected.append(.init(name: "locationName", value: "London"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.distanceFromLocation = 7
        expected.append(.init(name: "distanceFromLocation", value: "7"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.typeOptions = [.contract, .permanent, .partTime, .fullTime, .temp, .graduate]
        expected.append(.init(name: "permanent", value: "true"))
        expected.append(.init(name: "contract", value: "true"))
        expected.append(.init(name: "temp", value: "true"))
        expected.append(.init(name: "partTime", value: "true"))
        expected.append(.init(name: "fullTime", value: "true"))
        expected.append(.init(name: "graduate", value: "true"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.minimumSalary = 30000
        expected.append(.init(name: "minimumSalary", value: "30000"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.maximumSalary = 30000
        expected.append(.init(name: "maximumSalary", value: "30000"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.listingOptions = [.postedByDirectEmployer, .postedByRecruitmentAgency]
        expected.append(.init(name: "postedByRecruitmentAgency", value: "true"))
        expected.append(.init(name: "postedByDirectEmployer", value: "true"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
    
        vut.resultsToTake = 25
        expected.append(.init(name: "resultsToTake", value: "25"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
        
        vut.resultsToSkip = 0
        expected.append(.init(name: "resultsToSkip", value: "0"))
        XCTAssertEqual(expected, vut.convertToURLQueryItems())
    }
}
