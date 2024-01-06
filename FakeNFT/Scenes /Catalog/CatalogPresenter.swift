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
    func sortingByName()
    func sortingByCount()
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Properties
    weak var view: NftCatalogView?
    private let service: NftCatalogServiceProtocol
    var collectionsNFT: [NFTCollection] = []
    private var sortingKey = "sorting"
    private var sorting: Sorting? {
        get{
            guard let value = UserDefaults.standard.value(forKey: sortingKey) as? Int else {return nil}
            return Sorting(rawValue: value)
        }
        set (newValue){
            UserDefaults.standard.set(newValue?.rawValue, forKey: sortingKey)
        }
    }
    
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
                //проверить сохранена ли сортировка
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
    
    
    // MARK: - Sorting
    
    func sortingByCount(){
        sorting = .count
        collectionsNFT = collectionsNFT.sorted{ $0.nfts.count > $1.nfts.count }
        view?.update()
        //TODO: сохранить сортировку
        
        
    }
    
    func sortingByName(){
        sorting = .name
        collectionsNFT = collectionsNFT.sorted{ ($0.author.first ?? " ") <= ($1.author.first ?? " ") }
        view?.update()
    }
    
}
