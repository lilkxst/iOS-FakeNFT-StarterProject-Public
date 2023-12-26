//
//  NFTCatalogService.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 19.12.2023.
//

import Foundation

typealias NftCollectionsCompletion = (Result< [NFTCollection], Error>) -> Void
typealias ProfileCompletion = (Result< Profile, Error>) -> Void

protocol NftCatalogServiceProtocol {
    func loadNft(completion: @escaping NftCollectionsCompletion)
    func loadProfile( completion: @escaping ProfileCompletion)
    func setLike(id: String, completion: @escaping ProfileCompletion)
    func likeState(for id:String) -> Bool
}

final class NftCatalogService: NftCatalogServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: NftLikeStorageProtocol
    private var likes: Set<String> = []

    init(networkClient: NetworkClient, storage: NftLikeStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
        loadProfile(completion: {_ in })
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
                        self?.storage.saveLikeNft($0)
                    }
                }
                completion(.success(profile))
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
            storage.saveLikeNft(id)
        }
        
        let request = LikeRequest(likes: storage.storage)
        print("лайки - \(storage.storage)")
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                // сохранить новый массив лайков
                profile.likes.forEach{
                    self.storage.saveLikeNft($0)
                }
                print("Ответ, лайки - \(profile.likes)")
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func likeState(for id:String) -> Bool {
       storage.getNft(with: id) == nil ? false : true
    }
    
}
