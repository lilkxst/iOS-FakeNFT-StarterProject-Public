//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.12.23.
//

import Foundation
import UIKit

protocol CartPresenterProtocol {
    func totalPrice() -> Float
    func count() -> Int
    func getOrder()
    func getNftById(id: String)
    func setOrder()
    func getModel(indexPath: IndexPath) -> NftDataModel
    func sortCart(filter: CartFilter.FilterBy)
}

final class CartPresenter: CartPresenterProtocol {
    
    private weak var viewController: CartViewControllerProtocol?
    private var orderService: OrderService?
    private var nftByIdService: NftByIdService?
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"
    private var currentFilter: CartFilter.FilterBy {
        get {
            let id = userDefaults.integer(forKey: filterKey)
            return CartFilter.FilterBy(rawValue: id) ?? .id
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: filterKey)
        }
    }
    
    var cartContent: [NftDataModel] = []
    var orderIds: [String] = []
    var order: OrderDataModel?
    var nftById: NftDataModel?
    
    init(viewController: CartViewControllerProtocol, orderService: OrderService, nftByIdService: NftByIdService) {
        self.viewController = viewController
        self.orderService = orderService
        self.nftByIdService = nftByIdService
    }
        
    func totalPrice() -> Float {
        var price: Float = 0
        for nft in cartContent {
            price += nft.price
        }
        return price
    }
    
    func count() -> Int {
        let count: Int = cartContent.count
        return count
    }
        
    func getOrder() {
        orderService?.loadOrder() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let order):
                    self.order = order
                    if !order.nfts.isEmpty {
                        order.nfts[0].components(separatedBy: ",").forEach { data in
                            self.orderIds.append(data)
                        }
                        for nftsIds in self.orderIds {
                            self.getNftById(id: nftsIds)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getNftById(id: String) {
        nftByIdService?.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nftById = nft
                    self.cartContent.append(self.nftById!)
                    viewController?.showPlaceholder()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func setOrder() {
        guard let order = self.orderService?.nftsStorage else { return }
        self.cartContent = order
    }
    
    func getModel(indexPath: IndexPath) -> NftDataModel {
        let model = cartContent[indexPath.row]
        return model
    }
    
    func sortCart(filter: CartFilter.FilterBy) {
        currentFilter = filter
        cartContent = cartContent.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById)
    }
}
