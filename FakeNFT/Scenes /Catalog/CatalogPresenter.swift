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
    private let sortingStorage: SortingNftStorage
    var collectionsNFT: [NFTCollection] = []
    
  
    
    // MARK: - Init
    convenience init(service: NftCatalogServiceProtocol ){
        let storage = SortingNftStorage()
        self.init(service: service, sortingStorage: storage)
    }

    init(service: NftCatalogServiceProtocol, sortingStorage: SortingNftStorage) {
        self.service = service
        self.sortingStorage = sortingStorage
    }
    
    // MARK: - Functions
    
    func getCollections(){
        view?.startLoadIndicator()
        service.loadNft( completion: { [weak self] result in
            switch result {
            case .success(let collections):
                self?.collectionsNFT = collections
                //проверить сохранена ли сортировка
                self?.checkSorting()
                self?.view?.stopLoadIndicator()
                self?.view?.update()
            case .failure(let error):
                print(error)
                self?.view?.stopLoadIndicator()
                self?.view?.showLoadingAlert()
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
    
    private func checkSorting(){
        //Проверяем сохранена ли сортировка
        let sorting = sortingStorage.getSorting()
        switch sorting {
        case .byName:
            sortingByName()
        case .byCount:
            sortingByCount()
        }
    }
    
    func sortingByCount(){
        sortingStorage.saveSorting(.byCount)
        collectionsNFT = collectionsNFT.sorted{ $0.nfts.count > $1.nfts.count }
        view?.update()
    }
    
    func sortingByName(){
        sortingStorage.saveSorting(.byName)
        collectionsNFT = collectionsNFT.sorted{ $0.name < $1.name }
        view?.update()
    }
    
}
