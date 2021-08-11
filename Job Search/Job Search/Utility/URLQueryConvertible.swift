//
//  URLQueryConvertible.swift
//  Job Search
//
//  Created by Uncreation on 11/08/2021.
//

import Foundation

/// Denotes that a value or object subscribing to this protocol can be converted into an array of `URLQueryItem` values.
protocol URLQueryConvertible {
    /// The contents of this value/object as represented by an array of `URLQueryItem` values.
    func convertToURLQueryItems() -> [URLQueryItem]
}
