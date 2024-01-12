//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import Foundation

typealias CurrenciesCompletion = (Result<[CurrencyDataModel], Error>) -> Void

protocol PaymentService {
    func getCurrencies(completion: @escaping CurrenciesCompletion)
}

final class PaymentServiceImpl: PaymentService {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()
        
        networkClient.send(request: request, type: [CurrencyDataModel].self) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
