//
//  Filter.swift
//  FakeNFT
//
//  Created by Артём Костянко on 10.01.24.
//

import Foundation

struct CartFilter {
    
    typealias FilterClosure = (NftDataModel, NftDataModel) -> Bool
    
    enum FilterBy: Int {
        case id
        case price
        case rating
        case title
    }
    
    static var filterById: FilterClosure = { a, b in
        return a.id < b.id
    }
    
    static var filterByPrice: FilterClosure = { a, b in
        return a.price < b.price
    }
    
    static var filterByRating: FilterClosure = { a, b in
        return a.rating > b.rating
    }
    
    static var filterByTitle: FilterClosure = { a, b in
        return a.name < b.name
    }
    
    static let filter: [FilterBy:FilterClosure] = [.id: filterById, .price: filterByPrice, .rating: filterByRating, .title: filterByTitle]
}
