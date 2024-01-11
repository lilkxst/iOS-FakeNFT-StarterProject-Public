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
    
    // MARK: - Initialization
    
    init(networkClient: NetworkClient, storage: CatalogStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
        loadProfile{ _ in }
        loadOrders { _ in }
    }
    
    // MARK: - Functions
    
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
        var likes = storage.likes
        
        //Проверка на наличие nft во множестве лайков
        if let _ = storage.getNft(with: id) {
            //нужно удалить nft, убираем лайк
            likes.remove(id)
        } else {
            //нужно добавить nft, ставим лайк
            likes.insert(id)
        }
        
        let request = LikeRequest(likes: likes)
        
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                //очищаем старый массив
                self?.storage.likes.removeAll()
                
                // сохранить новый массив лайков
                if !profile.likes.isEmpty{
                    //Сохраняем массив nft пользователя
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
    
    func setOrders(id: String, completion: @escaping OrdersCompletion) {
        var orders = storage.orders
        //Проверка на наличие nft в заказе
        if storage.finderInOrders(id) {
            //нужно удалить nft, убираем из заказа
            orders.remove(id)
        } else {
            //нужно добавить nft в заказ
            orders.insert(id)
        }
        
        let request = OrdersPutRequest(id: storage.orderId ?? "", orders: orders)
        
        networkClient.send(request: request, type: Orders.self) { [weak self] result in
            switch result {
            case .success(let orders):
                //Сохраняем id заказа
                self?.storage.saveOrderId(orderId: orders.id)
                //очищаем старый заказ
                self?.storage.orders.removeAll()
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
    
    func likeState(for id:String) -> Bool {
        storage.getNft(with: id) != nil
    }
    
    func basketState(for id:String) -> Bool {
        storage.finderInOrders(id)
    }
    
}
