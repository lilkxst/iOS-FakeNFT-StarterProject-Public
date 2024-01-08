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
protocol NFTServiceProtocol {
    func fetchNFTs(completion: @escaping (Result<[Nft], Error>) -> Void)
    func loadNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {

    private var nfts: [Nft] = []
    private let nftService: NFTServiceProtocol
    private var loadedNFTsCount = 0
    weak var view: UserCollectionViewProtocol?

    init(view: UserCollectionViewProtocol, nftService: NFTServiceProtocol) {
           self.view = view
           self.nftService = nftService
       }

    func viewDidLoad() {
        nftService.fetchNFTs { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    print("Успешно получены данные NFT: \(nfts)")
                    self?.nfts = nfts
                    self?.view?.refreshUI()
                case .failure(let error):
                    print("Ошибка при загрузке данных NFT: \(error)")
                    self?.view?.displayError(error)
                }
            }
        }
    }

    func numberOfItems() -> Int {
        return nfts.count
    }

    func loadUserNFTs(nfts nftsIDs: [String], likedNFTs: [String]) {
          self.nfts.removeAll()
          self.loadedNFTsCount = 0

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
