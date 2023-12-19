//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 19.12.2023.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/collections")

    }
}
