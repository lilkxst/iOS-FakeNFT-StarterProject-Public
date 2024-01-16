//
//  PayRequest.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import Foundation

struct PayRequest: NetworkRequest {
    
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}
