//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 10.12.2023.
//

import Foundation

protocol CatalogPresenterProtocol {
    var collectionsNFT:  [NFTCollection] { get }
    var view: NftCatalogView? { get set }
    func getCollections()
    func getModel(for indexPath: IndexPath) -> CatalogNFTCellViewModel
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Properties
    weak var view: NftCatalogView?
    private let service: NftCatalogServiceProtocol
    var collectionsNFT: [NFTCollection] = []
    
    // MARK: - Init

    init(service: NftCatalogServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Functions
    
    func getCollections(){
        service.loadNft( completion: { [weak self] result in
            switch result {
            case .success(let collections):
                self?.collectionsNFT = collections
                self?.view?.update()
            case .failure(let error):
                print(error)
            }
        }
        )
    }
    
    func getModel(for indexPath: IndexPath) -> CatalogNFTCellViewModel {
        convertToViewModel(collection: collectionsNFT[indexPath.row])
    }
    
    func convertToViewModel(collection: NFTCollection) -> CatalogNFTCellViewModel {
        CatalogNFTCellViewModel(
            nameNFT: collection.name ,
            countNFT: collection.nfts.count,
            url:  URL(string: collection.cover)!
        )
    }
    
}
