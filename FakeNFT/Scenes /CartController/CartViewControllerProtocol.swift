//
//  CartViewControllerProtocol.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.12.23.
//

import Foundation


protocol CartViewControllerProtocol: AnyObject {
    func showPlaceholder()
    func updateCartTable()
    func startLoadIndicator()
    func stopLoadIndicator()
}
