//
//  CollectionNFTPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 15.12.2023.
//

import UIKit

protocol CollectionPresenterProtocol {
    var nfts: [Nft] { get }
    var view: NftCollectionView? { get set }
    func load()
    func getModel(for indexPath: IndexPath) -> CollectionNFTCellViewModel
    func changeLikeState(for indexPath: IndexPath, state: Bool)
    
}


final class CollectionNFTPresenter: CollectionPresenterProtocol {
    
    
    // MARK: - Properties
    weak var view: NftCollectionView?
    private let service: ServicesAssembly
    var collection: NFTCollection?
    var profile: Profile?
    var nfts: [Nft] = []
    
    // MARK: - Init
    
    init(service: ServicesAssembly, collection: NFTCollection?) {
        self.service = service
        self.collection = collection
        getNFTs()
        //getProfile()
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
    
    func getProfile(){
        service.nftCatalogService.loadProfile(completion: {[weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getModel(for indexPath: IndexPath) -> CollectionNFTCellViewModel {
        convertToViewModel(nft: nfts[indexPath.row])
    }
    
    func convertToViewModel(nft: Nft) -> CollectionNFTCellViewModel {
        CollectionNFTCellViewModel(
            id: nft.id,
            nameNFT: nft.name,
            price: String(nft.price),
            isLiked: service.nftCatalogService.likeState(for: nft.id),
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
    
    // MARK: - Cells Functions
    
    func changeLikeState(for indexPath: IndexPath, state: Bool) {
        
        service.nftCatalogService.setLike(id: nfts[indexPath.row].id, completion: {[weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                //обновить ячейку
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
}
