//
//  NftLikeStorage.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 26.12.2023.
//

import Foundation

protocol CatalogStorageProtocol: AnyObject {
    var likes: Set<String> { get set }
    var orders: Set<String> { get set }
    var orderId: String? { get }
    func saveNft(_ nft: String)
    func getNft(with id: String) -> String?
    func deleteNft(with id: String)
    func saveOrderId(orderId: String)
    func saveOrders(_ nft: String)
    func deleteOrders(with id: String)
    func finderInOrders(_ nft: String) -> Bool
}

final class CatalogStorage: CatalogStorageProtocol {
    
    static var shared = CatalogStorage()
    var likes: Set<String> = []
    var orders: Set<String> = []
    var orderId: String?
    static let DidChangeProfileNotification = Notification.Name(rawValue: "ProfileDidChange")
    private var profile: ProfileModelNetwork? {
        didSet{
            NotificationCenter.default.post(
                name: CatalogStorage.DidChangeProfileNotification,
                object: self,
                userInfo: ["Profile" : profile ])
        }
    }

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.likes.insert(nft)
        }
    }

    func getNft(with id: String) -> String? {
        return syncQueue.sync {
            likes.first(where: {$0 == id })
        }
    }

    func deleteNft(with id: String) {
        syncQueue.async { [weak self] in
            self?.likes.remove(id)
        }
    }

    func saveOrderId(orderId: String) {
        syncQueue.async { [weak self] in
            self?.orderId = orderId
        }
    }

    func saveOrders(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.orders.insert(nft)
        }
    }

    func deleteOrders(with id: String) {
        syncQueue.async { [weak self] in
            self?.orders.remove(id)
        }
    }

    func finderInOrders(_ nft: String) -> Bool {
        orders.contains(nft)
    }
    

}

extension CatalogStorage: ProfileStorageProtocol {
    
    func saveProfile(_ profile: ProfileModelNetwork) {
        syncQueue.async { [weak self] in
            self?.profile = profile
        }
    }

    func getProfile() -> ProfileModelNetwork? {
        syncQueue.sync { [weak self] in
            return self?.profile
        }
    }
    
}
