//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by MARIIA on 04.01.24.
//

import Foundation

protocol UserCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfItems() -> Int
    func item(at index: Int) -> Nft?
    func loadUserNFTs(nfts: [String])
    func toggleLikeStatus(for nftId: String, completion: @escaping () -> Void)
    func toggleCartStatus(for nftId: String, completion: @escaping () -> Void)
    func isNftLiked(_ nftId: String) -> Bool
    func isNftInCart(_ nftId: String) -> Bool
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {

    private var nfts: [Nft] = []
    private let nftService: NftService
    private var networkClient: NetworkClient?
    private var loadedNFTsCount = 0
    private var totalNFTsCount = 0
    private var likedNFTsIds: [String] = []
    private var cartNFTsIds: [String] = []
    private weak var view: UserCollectionViewProtocol?
    var user: User?

    init(view: UserCollectionViewProtocol, nftService: NftService) {
        self.view = view
        self.nftService = nftService
    }

    func viewDidLoad() {
        guard let nftsIDs = user?.nfts else {
            return
        }
        loadUserNFTs(nfts: nftsIDs)
    }

    func numberOfItems() -> Int {
        return nfts.count
    }

    func loadUserNFTs(nfts nftsIDs: [String]) {
        self.nfts.removeAll()
        self.loadedNFTsCount = 0
        self.totalNFTsCount = nftsIDs.count

        for nftID in nftsIDs {
            nftService.loadNft(id: nftID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(var nft):
                        self?.nfts.append(nft)
                        self?.incrementAndCheckLoadedCount()
                    case .failure(let error):
                        print("Ошибка при загрузке NFT: \(error)")
                        self?.incrementAndCheckLoadedCount()
                    }
                }
            }
        }
    }

    private func incrementAndCheckLoadedCount() {
        loadedNFTsCount += 1
        if loadedNFTsCount == totalNFTsCount {
            view?.refreshUI()
        }
    }

    func item(at index: Int) -> Nft? {
        guard index >= 0 && index < nfts.count else { return nil }
        return nfts[index]
    }

    func toggleLikeStatus(for nftId: String, completion: @escaping () -> Void) {
        if likedNFTsIds.contains(nftId) {
            likedNFTsIds.removeAll { $0 == nftId }
        } else {
            likedNFTsIds.append(nftId)
        }
        updateNftStatus(nftId: nftId, in: &likedNFTsIds)
        completion()
    }

    func toggleCartStatus(for nftId: String, completion: @escaping () -> Void) {
        if cartNFTsIds.contains(nftId) {
            cartNFTsIds.removeAll { $0 == nftId }
        } else {
            cartNFTsIds.append(nftId)
        }
        updateNftStatus(nftId: nftId, in: &cartNFTsIds)
        completion()
    }

    private func updateNftStatus(nftId: String, in array: inout [String]) {
        view?.refreshUI()
    }
    func isNftLiked(_ nftId: String) -> Bool {
        return likedNFTsIds.contains(nftId)
    }

    func isNftInCart(_ nftId: String) -> Bool {
        return cartNFTsIds.contains(nftId)
    }
}
