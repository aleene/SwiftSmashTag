//
//  SearchQuery.swift
//  SwiftSmashTag
//
//  Created by arnaud on 29/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import Foundation

public struct SearchQuery {
    
    public var queries = [String]()
    
    private var defaults = NSUserDefaults()
    
    private struct Constants {
        static let HistoryKey = "History Key"
        static let HistorySize = 100
    }
    
    init() {
        // get the NSUserdefaults array with search strings
        defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(Constants.HistoryKey) != nil {
            queries = defaults.arrayForKey(Constants.HistoryKey) as! [String]
        }
    }
    
    // see also http://stackoverflow.com/questions/30790882/unable-to-append-string-to-array-in-swift/30790932#30790932
    //
    mutating func addQuery(query query: String?) {
        if let newQuery = query {
            // is this query new?
            if !queries.contains(newQuery) {
                queries.insert(newQuery, atIndex: 0)
                if queries.count > Constants.HistorySize {
                    queries.removeLast()
                }
            }
            defaults.setObject(queries, forKey: Constants.HistoryKey)
        }
    }
    
    mutating func deleteQuery(query query: String?) {
        if let queryToDelete = query {
            if let deleteIndex = queries.indexOf(queryToDelete) {
                queries.removeAtIndex(deleteIndex)
            }
        }
    }
}