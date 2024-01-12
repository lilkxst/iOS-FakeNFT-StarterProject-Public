//
//  Orders.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 27.12.2023.
//

import Foundation

// MARK: - Orders

struct Orders: Codable {
    let nfts: [String]
    let id: String
}
