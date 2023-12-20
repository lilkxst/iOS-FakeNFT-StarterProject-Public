//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 15.12.2023.
//

import UIKit

protocol CollectionPresenterProtocol {
    var collectionCells: [CollectionNFTCellViewModel] { get }
    var nfts: [Nft] { get }
    var view: NftCollectionView? { get set }
    func load()
    func getModel(for indexPath: IndexPath) -> CollectionNFTCellViewModel
    
}


final class CollectionNFTPresenter: CollectionPresenterProtocol {
    
    
    // MARK: - Properties
    weak var view: NftCollectionView?
    private let service: ServicesAssembly
    var collection: NFTCollection?
    var nfts: [Nft] = []
    var collectionCells: [CollectionNFTCellViewModel] = custonCollectionCells
    
    // MARK: - Init
    
    init(service: ServicesAssembly, collection: NFTCollection?) {
        self.service = service
        self.collection = collection
        getNFTs()
    }
    
    // MARK: - Functions
    
    func load(){
        guard let collection else { return }
        view?.setup(name: collection.name, cover: collection.cover, author: convertAuthor(), description: collection.description)
    }
    
    func getNFTs(){
        guard let collection,
              !collection.nfts.isEmpty else { return }
        
        //Сделать запросы по ID
        collection.nfts.forEach{
                service.nftService.loadNft(id: $0, completion: { [weak self] result in
                    switch result {
                    case .success(let nft):
                        self?.nfts.append(nft)
                        self?.view?.updateCollection()
                    case .failure(let error):
                        print(error)
                    }
                })
            }
    }
    
    func getModel(for indexPath: IndexPath) -> CollectionNFTCellViewModel {
        convertToViewModel(nft: nfts[indexPath.row])
    }
    
    func convertToViewModel(nft: Nft) -> CollectionNFTCellViewModel {
        CollectionNFTCellViewModel(
            nameNFT: nft.name,
            price: String(nft.price),
            isLiked: true,
            isInTheBasket: true,
            rating: nft.rating,
            url: URL(string: nft.images[0])!
        )
    }
    
    func convertAuthor()-> String {
        let names = collection?.author.components(separatedBy: "_")
        let name = (names?[0] ?? "") + " " + (names?[1] ?? "")
        return name.capitalized
    }
    
}


let custonCollectionCells: [CollectionNFTCellViewModel] = [
    CollectionNFTCellViewModel(nameNFT: "Archi", price: "1", isLiked: true, isInTheBasket: true, rating: 2, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Ruby", price: "2", isLiked: true, isInTheBasket: true, rating: 0, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Doritos", price: "11", isLiked: false, isInTheBasket: false, rating: 5, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "Cheatos", price: "12", isLiked: true, isInTheBasket: false, rating: 4, url: URL(string: "https://practicum.yandex.ru")!),
    CollectionNFTCellViewModel(nameNFT: "lays", price: "13", isLiked: false, isInTheBasket: true, rating: 3, url: URL(string: "https://practicum.yandex.ru")!)
    
]
