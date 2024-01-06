//
//  NFTCollections.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 19.12.2023.
//

import Foundation

// MARK: - NFTCollections

struct NFTCollection: Codable {
    let createdAt, name: String
    let cover: String
    let nfts: [String]
    let description, author, id: String
}
