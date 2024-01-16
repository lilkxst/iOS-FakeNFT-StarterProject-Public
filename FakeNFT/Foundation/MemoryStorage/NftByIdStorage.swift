//
//  NftByIdStorage.swift
//  FakeNFT
//
//  Created by Артём Костянко on 24.12.23.
//

import Foundation

protocol NftByIdStorage: AnyObject {
    func saveNftById(_ nftById: NftDataModel)
    func getNftById(with id: String) -> NftDataModel?
}

final class NftByIdStorageImpl: NftByIdStorage{

    private var storage: [String: NftDataModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-order-queue")

    func saveNftById(_ nftById: NftDataModel) {
        syncQueue.async { [weak self] in
            self?.storage[nftById.id] = nftById
        }
    }

    func getNftById(with id: String) -> NftDataModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
