//
//  CartDeletePresenter.swift
//  FakeNFT
//
//  Created by Артём Костянко on 8.01.24.
//

import UIKit

protocol CartDeletePresenterProtocol {
    var nftImage: UIImage { get }
    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void)
}

final class CartDeletePresenter: CartDeletePresenterProtocol {
    
    private weak var viewController: CartDeleteControllerProtocol?
    private var orderService: OrderService?
    private var nftIdForDelete: String
    private (set) var nftImage: UIImage
    
    init(viewController: CartDeleteControllerProtocol, orderService: OrderService, nftIdForDelete: String, nftImage: UIImage) {
        self.viewController = viewController
        self.orderService = orderService
        self.nftIdForDelete = nftIdForDelete
        self.nftImage = nftImage
    }
    
    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void) {
        viewController?.startLoadIndicator()
        orderService?.removeNftFromStorage(id: nftIdForDelete, completion: { result in
            switch result {
            case let .success(data):
                self.viewController?.stopLoadIndicator()
                completion(.success(data))
            case let .failure(error):
                self.viewController?.showNetworkError(message: "\(error)")
                self.viewController?.stopLoadIndicator()
                print(error)
            }
        } )
    }
}
