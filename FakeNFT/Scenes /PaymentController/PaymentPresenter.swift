//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import Foundation

protocol PaymentPresenterProtocol {
    func count() -> Int
    func getCurrencies()
    func getModel(indexPath: IndexPath) -> CurrencyDataModel
}

final class PaymentPresenter: PaymentPresenterProtocol {
    
    private var paymentService: PaymentService?
    private var currencies: [CurrencyDataModel] = []
    
    init(paymentService: PaymentService) {
        self.paymentService = paymentService
    }
    
    func getCurrencies() {
        paymentService?.getCurrencies { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                switch result {
                case let .success(data):
                    self?.currencies = data
                    print(self?.currencies)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func getModel(indexPath: IndexPath) -> CurrencyDataModel {
        let model = currencies[indexPath.row]
        print("MODEL \(model)")
        return model
    }
    
    func count() -> Int {
        let count: Int = currencies.count
        return count
    }
}
