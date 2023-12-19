//
//  NFTCatalogService.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 19.12.2023.
//

import Foundation

typealias NftCollectionsCompletion = (Result< [NFTCollection], Error>) -> Void

protocol NftCatalogServiceProtocol {
    func loadNft(completion: @escaping NftCollectionsCompletion)
}

final class NftCatalogService: NftCatalogServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft( completion: @escaping NftCollectionsCompletion) {
      
       let request = CollectionsRequest()
        
        networkClient.send(request: request, type: [NFTCollection].self) { [weak storage] result in
            switch result {
            case .success(let collections):
               // storage?.saveNft(nft)
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
