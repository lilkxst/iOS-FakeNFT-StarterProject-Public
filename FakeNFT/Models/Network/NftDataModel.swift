//
//  NftDataModel.swift
//  FakeNFT
//
//  Created by Артём Костянко on 15.12.23.
//

import Foundation

struct NftDataModel: Decodable {
    var createdAt: String
    var name: String
    var images: [String]
    var rating: Int
    var description: String
    var price: Float
    var author: String
    var id: String
}
