final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let nftLikeStorage: NftLikeStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        nftLikeStorage: NftLikeStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftLikeStorage = nftLikeStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var nftCatalogService: NftCatalogServiceProtocol {
        NftCatalogService(
            networkClient: networkClient,
            storage: nftLikeStorage
        )
    }
    
}
