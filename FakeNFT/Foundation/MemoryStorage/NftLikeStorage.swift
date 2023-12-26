//
//  NftLikeStorage.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 26.12.2023.
//

import Foundation

protocol NftLikeStorageProtocol: AnyObject {
    func saveLikeNft(_ nft: String)
    func getNft(with id: String) -> String?
    func deleteNft(with id: String)
    var storage: Set<String> { get }
}


final class NftLikeStorage: NftLikeStorageProtocol {
    var storage: Set<String> = []

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveLikeNft(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.storage.insert(nft)
            print("лайки - \(self?.storage)")
        }
    }

    func getNft(with id: String) -> String? {
        print(id)
        print(storage)
       return syncQueue.sync {
            storage.first(where: { nft in nft == id } )
        }
    }
    
    func deleteNft(with id: String) {
        syncQueue.sync { [weak self] in
            self?.storage.remove(id)
        }
    }
    
}
