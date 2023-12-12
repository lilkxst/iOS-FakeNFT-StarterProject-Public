//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.12.23.
//

import Foundation


final class CartPresenter {
    
    private var viewController: CartViewControllerProtocol?
    
    var cartContent: [NftModel] = []
    
    init(viewController: CartViewControllerProtocol) {
        self.viewController = viewController
    }
}
