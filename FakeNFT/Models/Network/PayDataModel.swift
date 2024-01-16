//
//  PayDataModel.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import Foundation

struct PayDataModel: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
