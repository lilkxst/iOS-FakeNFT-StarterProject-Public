//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 10.12.2023.
//

import Foundation

protocol CatalogPresenterProtocol {
    var collectionsNFT: [CatalogNFTCellViewModel] { get }
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Properties
    weak var view: NftCatalogView?
    private let service: NftService 
    var collectionsNFT: [CatalogNFTCellViewModel] = custonCollectionsNFT
    
    // MARK: - Init

    init(service: NftService) {
        self.service = service
    }
    
    // MARK: - Functions
    
}


let custonCollectionsNFT: [CatalogNFTCellViewModel] = [
    CatalogNFTCellViewModel(nameNFT: "Peach", countNFT: 12, url: URL(string: "https://practicum.yandex.ru")! ),
    CatalogNFTCellViewModel(nameNFT: "Blue", countNFT: 7, url: URL(string: "https://practicum.yandex.ru")! ),
    CatalogNFTCellViewModel(nameNFT: "Brown", countNFT: 5, url: URL(string: "https://practicum.yandex.ru")! ),
    CatalogNFTCellViewModel(nameNFT: "Peach", countNFT: 12, url: URL(string: "https://practicum.yandex.ru")! ),
]
