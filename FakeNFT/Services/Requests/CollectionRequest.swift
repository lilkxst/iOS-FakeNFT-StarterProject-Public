//
//  CollectionRequest.swift
//  FakeNFT
//
//  Created by Артём Костянко on 24.12.23.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/collections")

    }
}
