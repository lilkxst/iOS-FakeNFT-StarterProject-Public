//
//  NftCellDelegateProtocol.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 26.12.2023.
//

import Foundation

public protocol NftCellDelegate {
    func changeLike(for indexPath: IndexPath, state: Bool)
    func changeOrder(for indexPath: IndexPath)
}
