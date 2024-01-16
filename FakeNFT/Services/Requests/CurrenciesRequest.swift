//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/currencies")

    }
}
