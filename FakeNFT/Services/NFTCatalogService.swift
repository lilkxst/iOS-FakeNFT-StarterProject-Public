//
//  NFTCatalogService.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 19.12.2023.
//

import Foundation

typealias NftCollectionsCompletion = (Result< [NFTCollection], Error>) -> Void
typealias ProfileCompletion = (Result< Profile, Error>) -> Void
typealias OrdersCompletion = (Result< Orders, Error>) -> Void

protocol NftCatalogServiceProtocol {
    func loadNft(completion: @escaping NftCollectionsCompletion)
    func loadProfile( completion: @escaping ProfileCompletion)
    func loadOrders( completion: @escaping OrdersCompletion)
    func setLike(id: String, completion: @escaping ProfileCompletion)
    func setOrders(id: String, completion: @escaping OrdersCompletion)
    func likeState(for id:String) -> Bool
    func basketState(for id:String) -> Bool
}

final class NftCatalogService: NftCatalogServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: CatalogStorageProtocol

    init(networkClient: NetworkClient, storage: CatalogStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
        loadProfile{ _ in }
        loadOrders { _ in }
    }

    func loadNft( completion: @escaping NftCollectionsCompletion) {
      
       let request = CollectionsRequest()
        
        networkClient.send(request: request, type: [NFTCollection].self) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadProfile( completion: @escaping ProfileCompletion) {
      
       let request = ProfileRequest()
        
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                //Проверяем не пустой ли массив лайков
                if !profile.likes.isEmpty{
                    //Сохраняем массив лайков пользователя
                    profile.likes[0].components(separatedBy: ",").forEach{
                        self?.storage.saveNft($0)
                    }
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadOrders( completion: @escaping OrdersCompletion) {
      
       let request = OrdersGetRequest()
        
        networkClient.send(request: request, type: Orders.self) { [weak self] result in
            switch result {
            case .success(let orders):
                //Сохраняем id заказа
                self?.storage.saveOrderId(orderId: orders.id)
                //Сохраняем nft в заказе
                if !orders.nfts.isEmpty{
                    //Сохраняем массив nft пользователя
                    orders.nfts[0].components(separatedBy: ",").forEach{
                        self?.storage.saveOrders($0)
                    }
                }
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setLike(id: String, completion: @escaping ProfileCompletion) {
        //Проверка на наличие nft во множестве лайков
        if let nft = storage.getNft(with: id) {
            //нужно удалить nft
            storage.deleteNft(with: nft)
        } else {
            storage.saveNft(id)
        }
        
        let request = LikeRequest(likes: storage.likes)
        print("лайки - \(storage.likes)")
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                // сохранить новый массив лайков
                profile.likes.forEach{
                    self.storage.saveNft($0)
                }
                print("Ответ, лайки - \(profile.likes)")
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setOrders(id: String, completion: @escaping OrdersCompletion) {
        //Проверка на наличие nft во множестве лайков
        if storage.finderInOrders(id) {
            //нужно удалить nft
            storage.deleteOrders(with: id)
        } else {
            storage.saveOrders(id)
        }
        sleep(3)
        
        let request = OrdersPutRequest(id: storage.orderId ?? "", orders: storage.orders)
        print("Заказ - \(storage.orders)")
        print("Id - \(storage.orderId)")
       // print(request.ordersToString())
        networkClient.send(request: request, type: Orders.self) { [weak self] result in
            switch result {
            case .success(let orders):
                //Сохраняем id заказа
                print(orders)
                self?.storage.saveOrderId(orderId: orders.id)
                //Сохраняем nft в заказе
                orders.nfts.forEach{
                    self?.storage.saveOrders($0)
                }
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func likeState(for id:String) -> Bool {
       storage.getNft(with: id) == nil ? false : true
    }
    
    func basketState(for id:String) -> Bool {
       storage.finderInOrders(id)
    }
}
