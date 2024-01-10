//
//  changeOrderRequest.swift
//  FakeNFT
//
//  Created by Артём Костянко on 6.01.24.
//

import Foundation

struct ChangeOrderRequest: NetworkRequest {
    
    var httpMethod: HttpMethod { .put }
    var nfts: Encodable?
    
    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    init(nfts: [String]) {
        self.nfts = ChangedOrderDataModel(nfts: nfts)
    }
}
