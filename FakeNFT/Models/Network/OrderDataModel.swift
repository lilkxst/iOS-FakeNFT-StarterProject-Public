//
//  OrderDataModel.swift
//  FakeNFT
//
//  Created by Артём Костянко on 15.12.23.
//

import Foundation

struct OrderDataModel: Decodable {
    var nfts: [String]
    var id: String
}
