//
//  SortingStorage.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 06.01.2024.
//

import Foundation

protocol SortingNft {
    func saveSorting(_ type: Sorting)
    func getSorting()->Sorting?
}

final class SortingNftStorage: SortingNft {
    
    private var sortingKey = "sorting"
    private let userDefaults = UserDefaults.standard
    private var sorting: Sorting?
    
    func saveSorting(_ type: Sorting){
        userDefaults.set(type.rawValue, forKey: sortingKey)
    }
    
    func getSorting()->Sorting? {
        guard let value = userDefaults.value(forKey: sortingKey) as? String else {return nil}
        return Sorting(rawValue: value)
    }
    
}


enum Sorting: String {
    case byName
    case byCount
}


