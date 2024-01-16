//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import Foundation

protocol PaymentPresenterProtocol {
    var selectedCurrency: CurrencyDataModel? { get set }
    func count() -> Int
    func getCurrencies()
    func getModel(indexPath: IndexPath) -> CurrencyDataModel
    func payOrder()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    
    private weak var paymentController: PaymentViewControllerProtocol?
    private var paymentService: PaymentService?
    private var orderService: OrderService?
    private var currencies: [CurrencyDataModel] = []
    var selectedCurrency: CurrencyDataModel? {
        didSet {
            if selectedCurrency != nil {
            paymentController?.didSelectCurrency(isEnable: true)
            }
        }
    }
    
    init(paymentController: PaymentViewControllerProtocol, paymentService: PaymentService, orderService: OrderService) {
        self.paymentController = paymentController
        self.paymentService = paymentService
        self.orderService = orderService
    }
    
    func getCurrencies() {
        paymentController?.startLoadIndicator()
        paymentService?.getCurrencies { [weak self] result in
            guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.currencies = data
                    self.paymentController?.updateCurrencyList()
                    paymentController?.stopLoadIndicator()
                case let .failure(error):
                    print(error)
                    paymentController?.stopLoadIndicator()
            }
        }
    }
    
    func getModel(indexPath: IndexPath) -> CurrencyDataModel {
        let model = currencies[indexPath.row]
        return model
    }
    
    func count() -> Int {
        let count: Int = currencies.count
        return count
    }
    
    func payOrder() {
        paymentController?.startLoadIndicator()
        guard let selectedCurrency = selectedCurrency else { return }
        paymentService?.payOrder(currencyId: selectedCurrency.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                if (data.success) {
                    emptyCart()
                }
                paymentController?.didPayment(paymentResult: data.success)
                paymentController?.stopLoadIndicator()
            case .failure(_):
                paymentController?.didPayment(paymentResult: false)
                paymentController?.stopLoadIndicator()
            }
        }
    }
    
    func emptyCart() {
        orderService?.removeAllNftFromStorage() { result in
            switch result {
            case let .success(data):
                break
            case .failure(_):
                break
            }
        }
    }
}
