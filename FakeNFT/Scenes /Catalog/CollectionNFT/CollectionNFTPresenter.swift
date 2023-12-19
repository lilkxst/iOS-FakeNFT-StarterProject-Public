//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 15.12.2023.
//

import UIKit

protocol CollectionPresenterProtocol {
    var collectionCells: [CollectionNFTCellViewModel] { get }
    var view: NftCollectionView? { get set }
    func load()
    
}


final class CollectionNFTPresenter: CollectionPresenterProtocol {
    
    
    // MARK: - Properties
    weak var view: NftCollectionView?
    private let service: NftCatalogServiceProtocol
    var collection: NFTCollection?
    var collectionCells: [CollectionNFTCellViewModel] = custonCollectionCells
    
    // MARK: - Init
    
    init(service: NftCatalogServiceProtocol, collection: NFTCollection?) {
        self.service = service
        self.collection = collection
    }
    
    // MARK: - Functions
    
    func load(){
        guard let collection else { return }
        view?.setup(name: collection.name, cover: collection.cover, author: collection.author, description: collection.description)
    }
    
}


let custonCollectionCells: [CollectionNFTCellViewModel] = [
    CollectionNFTCellViewModel(nameNFT: "Archi", price: "1", isLiked: true, isInTheBasket: true, rating: 2, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Ruby", price: "2", isLiked: true, isInTheBasket: true, rating: 0, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Doritos", price: "11", isLiked: false, isInTheBasket: false, rating: 5, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Cheatos", price: "12", isLiked: true, isInTheBasket: false, rating: 4, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "lays", price: "13", isLiked: false, isInTheBasket: true, rating: 3, url: URL(string: "https://practicum.yandex.ru")!)
    
]
