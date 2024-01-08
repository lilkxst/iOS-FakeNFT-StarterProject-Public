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
    weak var view: UserCollectionViewProtocol?
    var user: User?

    init(view: UserCollectionViewProtocol, nftService: NftService) {
        print("Инициализация UserCollectionPresenter")
        self.view = view
        self.nftService = nftService
    }

    func viewDidLoad() {
        guard let nftsIDs = user?.nfts else {
            print("Не найдены ID NFT для загрузки")
            return
        }
        loadUserNFTs(nfts: nftsIDs, likedNFTs: user?.likes ?? [])
    }

    func numberOfItems() -> Int {
        return nfts.count
    }

    func loadUserNFTs(nfts nftsIDs: [String], likedNFTs: [String]) {
        print("Загрузка NFTs: \(nftsIDs)")
        print("Лайки: \(likedNFTs)")
        for nftID in nftsIDs {
            nftService.loadNft(id: nftID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        var updatedNft = nft
                        updatedNft.isLiked = likedNFTs.contains(nft.id)
                        self?.nfts.append(updatedNft)
                    case .failure(let error):
                        print("Ошибка при загрузке деталей NFT: \(error)")
                    }

                    self?.loadedNFTsCount += 1
                    print("Загружено \(self?.loadedNFTsCount ?? 0) из \(nftsIDs.count)")
                    if self?.loadedNFTsCount == nftsIDs.count {
                        self?.view?.refreshUI()
                    }
                }
            }
        }
    }

    func item(at index: Int) -> Nft? {
        guard index >= 0 && index < nfts.count else { return nil }
        return nfts[index]
    }
}
