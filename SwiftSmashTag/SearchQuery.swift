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
    }
    
    init() {
        // get the NSUserdefaults array with search strings
        defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(Constants.HistoryKey) != nil {
            queries = defaults.arrayForKey(Constants.HistoryKey) as! [String]
        }
    }
    
    mutating func addQuery(query query: String?) {
        if let newQuery = query {
            // is this query new?
            if !queries.contains(newQuery) {
                queries.insert(newQuery, atIndex: 0)
            }
            defaults.setObject(queries, forKey: Constants.HistoryKey)
        }
    }
    
}