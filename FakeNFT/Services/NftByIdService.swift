//
//  NftByIdService.swift
//  FakeNFT
//
//  Created by Артём Костянко on 24.12.23.
//

import Foundation

typealias NftByIdCompletion = (Result<NftDataModel, Error>) -> Void

protocol NftByIdService {
    func loadNft(id: String, completion: @escaping NftByIdCompletion)
}

final class NftByIdServiceImpl: NftByIdService {

    private let networkClient: NetworkClient
    private let storage: NftByIdStorage

    init(networkClient: NetworkClient, storage: NftByIdStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftByIdCompletion) {
        if let nft = storage.getNftById(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: NftDataModel.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNftById(nft)
                completion(.success(nft))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
