//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Артём Костянко on 21.12.23.
//

import Foundation

struct OrderRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
