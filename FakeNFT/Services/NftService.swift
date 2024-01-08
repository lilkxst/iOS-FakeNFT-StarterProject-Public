import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadCurrency(id: String, completion: @escaping (Result<Currency, Error>) -> Void)

}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func loadCurrency(id: String, completion: @escaping (Result<Currency, Error>) -> Void) {
        let request = CurrencyRequest(currencyId: id)
        networkClient.send(request: request, type: Currency.self) { result in
            completion(result)
        }
    }

}
