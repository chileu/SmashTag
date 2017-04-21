//
//  RecentSearches.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/20/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import Foundation

struct RecentSearches {
    
    private static let defaults = UserDefaults.standard
    
    private struct Constants {
        static let key = "RecentQueries"
        static let limit = 100
    }
    
    static var searches: [String] {
        return defaults.object(forKey: Constants.key) as? [String] ?? []
    }
    
    static func add(_ searchText: String) {
        var newArray = searches.filter { searchText.caseInsensitiveCompare($0) != .orderedSame }
        newArray.insert(searchText, at: 0)
        while newArray.count > Constants.limit {
            newArray.removeLast()
        }
        defaults.set(newArray, forKey: Constants.key)
    }
    
    static func delete(at index: Int) {
        var currentSearches = defaults.object(forKey: Constants.key) as? [String] ?? []
        currentSearches.remove(at: index)
        defaults.set(currentSearches, forKey: Constants.key)
    }
}
