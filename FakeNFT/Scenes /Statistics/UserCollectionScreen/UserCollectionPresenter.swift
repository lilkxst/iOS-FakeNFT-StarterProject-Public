//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by MARIIA on 04.01.24.
//

import Foundation

protocol UserCollectionPresenterProtocol {
    func viewDidLoad()
    func numberOfItems() -> Int
    func item(at index: Int) -> Nft?
    func loadUserNFTs(nfts: [String], likedNFTs: [String])
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {

    private var nfts: [Nft] = []
    private let nftService: NftService
    private var networkClient: NetworkClient?
    private var loadedNFTsCount = 0
    private var totalNFTsCount = 0
    weak var view: UserCollectionViewProtocol?
    var user: User?

    init(view: UserCollectionViewProtocol, nftService: NftService) {
        self.view = view
        self.nftService = nftService
    }

    func viewDidLoad() {
        guard let nftsIDs = user?.nfts else {
            return
        }
        loadUserNFTs(nfts: nftsIDs, likedNFTs: user?.likes ?? [])
    }

    func numberOfItems() -> Int {
        return nfts.count
    }

    func loadUserNFTs(nfts nftsIDs: [String], likedNFTs: [String]) {
        self.nfts.removeAll()
        self.loadedNFTsCount = 0
        self.totalNFTsCount = nftsIDs.count

        for nftID in nftsIDs {
            nftService.loadNft(id: nftID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(var nft):
                        nft.isLiked = likedNFTs.contains(nft.id)
                        nft.currency = Currency(title: "Mock", name: "ETN", image: "", id: "1")
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
}
