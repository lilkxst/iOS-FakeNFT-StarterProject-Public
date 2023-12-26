//
//  Profile.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 21.12.2023.
//

import Foundation

// MARK: - NFTCollections

struct Profile: Codable {
        let name: String
        let avatar: String
        let description: String
        let website: String
        let nfts: [String]
        let likes: [String]
        let id: String
}
