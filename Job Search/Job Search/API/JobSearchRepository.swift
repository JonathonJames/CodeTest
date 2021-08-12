//
//  JobSearchRepository.swift
//  Job Search
//
//  Created by Jonathon James on 12/08/2021.
//

import Foundation
import Combine

/// Repository for undertaking various tasks/"Use Cases".
struct JobSearchRepository {
    
    /// The underlying API which will perform the networking requests.
    let api: JobSearchAPI
    
    /// Performs a search with the specified query.
    /// - Parameter query: The query to run during the search.
    /// - Returns: A publisher which will publish the results of the search.
    func performSearch(_ query: JobSearchQuery) -> AnyPublisher<Result<JobListingSearchResult, Error>, Never>  {
        return self.api.performSearch(query)
    }
}


protocol JobSearchAPI {
    /// Performs a search with the specified query.
    /// - Parameter query: The query to run during the search.
    /// - Returns: A publisher which will publish the results of the search.
    func performSearch(_ query: JobSearchQuery) -> AnyPublisher<Result<JobListingSearchResult, Error>, Never>
}


/// A concrete implementation of the JobSearchAPI protocol.
struct JobSearchNetworkingDomain: JobSearchAPI {
    
    /// An exception that can occur when a URL is invalid.
    struct InvalidURLException: Error {
        let urlString: String
        var debugDescription: String {
            return "The string '\(self.urlString)' does not describe a valid URL."
        }
    }
    
    /// The base URL/host to use when constructing URLs.
    let baseURL: String
    /// The URLSession to use when performing network requests.
    let session: URLSession
    
    /// Performs a search with the specified query.
    /// - Parameter query: The query to run during the search.
    /// - Returns: A publisher which will publish the results of the search.
    func performSearch(_ query: JobSearchQuery) -> AnyPublisher<Result<JobListingSearchResult, Error>, Never> {
        do {
            var request: URLRequest = .init(url: try self.constructURL(baseURL: self.baseURL, path: "search", query: query))
            request.httpMethod = "GET"
            
            return self.session
                .dataTaskPublisher(for: request)
                .tryMap({ element -> Data in
                    guard let httpResponse: HTTPURLResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                            throw URLError(.badServerResponse)
                        }
                    return element.data
                })
                .decode(type: JobListingSearchResponse.self, decoder: JSONDecoder())
                .map({ .success(.init(query: query, response: $0)) })
                .catch({ error in
                    Just(.failure(error))
                        .eraseToAnyPublisher()
                })
                .subscribe(on: DispatchQueue(label: "Search queue", qos: .background))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Just(.failure(error))
                .eraseToAnyPublisher()
        }
    }
    
    /// A utility method for constructing a URL from a given base URL, path, and a query.
    /// - Parameters:
    ///   - baseURL: The host/base URL from which the endpoint should be constructed.
    ///   - path: The path/endpoint to hit relative to the base URL.
    ///   - query: The query to apply to the URL.
    /// - Throws: `InvalidURLException` if a valid URL cannot be constructed.
    /// - Returns: A new `URL` value.
    private func constructURL(baseURL: String, path: String, query: URLQueryConvertible) throws -> URL {
        
        guard var components: URLComponents = .init(string:  (baseURL as NSString).appendingPathComponent(path) ) else {
            throw InvalidURLException(urlString: baseURL)
        }
        
        components.queryItems = query.convertToURLQueryItems()
        
        guard let url: URL = components.url else {
            guard let string: String = components.string else {
                throw InvalidURLException(urlString: baseURL)
            }
            throw InvalidURLException(urlString: string)
        }
        
        return url
    }
}
