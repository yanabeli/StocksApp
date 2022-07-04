//
//  SearchResponse.swift
//  StocksApp
//
//  Created by Yana Beliakova on 02.07.22.
//

import Foundation

/// API response for search
struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

/// A single search result
struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
