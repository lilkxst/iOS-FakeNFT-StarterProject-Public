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
    func getNFTs()
    func getModel(for indexPath: IndexPath) -> CollectionNFTCellViewModel
    func changeLikeState(for indexPath: IndexPath, state: Bool)
    func changeOrderState(for indexPath: IndexPath)
    func getContentSize() -> Double?
    func getAuthorURL()-> URL?
}


final class CollectionNFTPresenter: CollectionPresenterProtocol {
    
    
    // MARK: - Properties
    weak var view: NftCollectionView?
    private let service: ServicesAssembly
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var collection: NFTCollection?
    var profile: Profile?
    var nfts: [Nft] = []
    
    // MARK: - Init
    
    init(service: ServicesAssembly, collection: NFTCollection?) {
        self.service = service
        self.collection = collection
    }
    
    // MARK: - Functions
    
    func getAuthorURL()-> URL?{
        let url = URL(string: "") //Тут должен лежать url на автора коллекции nfts[0].author
        return url
    }
    
    func getContentSize() -> Double? {
        guard let count = collection?.nfts.count else { return nil }
        // считаем размер коллекции, умножаем размер ячейки и отступа на количество строк
        let lineSize = (Double(count) / 3).rounded(.up )*(192 + 8 )
        //добавляем значения изображения и поисания коллекции, из макета
        let size = Double( 490 + lineSize)
        return size
    }
    
    func load(){
        guard let collection else { return }
        view?.setup(name: collection.name, cover: collection.cover, author: convertAuthor(), description: collection.description)
    }
    
    func getNFTs(){
        guard let collection,
              !collection.nfts.isEmpty else { return }
        
        collection.nfts.forEach{
            view?.startLoadIndicator()
            service.nftService.loadNft(id: $0, completion: { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                    self?.view?.stopLoadIndicator()
                    self?.view?.updateCollection()
                case .failure(let error):
                    self?.view?.stopLoadIndicator()
                    self?.view?.showLoadingAlert()
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
        var price: String
        if let formattedValue = formatter.string(from: NSNumber(value: nft.price )) {
            price = formattedValue
        } else {
            price = ""
        }
        
        return CollectionNFTCellViewModel(
            id: nft.id,
            nameNFT: nft.name,
            price: price,
            isLiked: service.nftCatalogService.likeState(for: nft.id),
            isInTheBasket: service.nftCatalogService.basketState(for: nft.id),
            rating: nft.rating,
            url: nft.images[0] 
        )
    }
    
    func convertAuthor()-> String {
        let names = collection?.author.components(separatedBy: "_")
        let name = (names?[0] ?? "") + " " + (names?[1] ?? "")
        return name.capitalized
    }
    
    // MARK: - Cells Functions
    
    func changeLikeState(for indexPath: IndexPath, state: Bool){
        
        service.nftCatalogService.setLike(id: nfts[indexPath.row].id, completion: {[weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                //обновить ячейку
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                print(error)
                self?.view?.updateCell(indexPath: indexPath)
            }
        })
        
    }
    
    func changeOrderState(for indexPath: IndexPath){
        
        service.nftCatalogService.setOrders(id: nfts[indexPath.row].id, completion: {[weak self] result in
            switch result {
            case .success:
                //обновить ячейку
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                print(error)
                self?.view?.updateCell(indexPath: indexPath)
            }
        })
    }
    
}
