//
//  OrderService.swift
//  FakeNFT
//
//  Created by Артём Костянко on 15.12.23.
//

import Foundation

typealias OrderCompletion = (Result<OrderDataModel, Error>) -> Void

protocol OrderService {
    var nftsStorage: [NftDataModel] { get }
    func loadOrder(completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
    
    private let networkClient: NetworkClient
    private let orderStorage: OrderStorage
    private let nftByIdService: NftByIdService
    private let nftStorage: NftByIdStorage
    private var idsStorage: [String] = []
    var nftsStorage: [NftDataModel] = []
    
    init(networkClietn: NetworkClient, orderStorage: OrderStorage, nftByIdService: NftByIdService, nftStorage: NftByIdStorage) {
        self.networkClient = networkClietn
        self.orderStorage = orderStorage
        self.nftByIdService = nftByIdService
        self.nftStorage = nftStorage
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest(id: "1")
        networkClient.send(request: request, type: OrderDataModel.self) { [weak orderStorage] result in
            switch result {
            case .success(let order):
                orderStorage?.saveOrder(order)
                self.idsStorage.append(contentsOf: order.nfts)
                for nftId in order.nfts {
                    self.nftByIdService.loadNft(id: nftId) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case let .success(nft):
                            self.nftStorage.saveNftById(nft)
                            self.nftsStorage.append(nft)
                        case let .failure(error):
                            print(error)
                            completion(.failure(error))
                        }
                    }
                }
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
