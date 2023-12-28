final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let catalogStorage: CatalogStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        catalogStorage: CatalogStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.catalogStorage = catalogStorage
        self.nftCatalogService =  NftCatalogService(
            networkClient: networkClient,
            storage: catalogStorage
        )
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var nftCatalogService: NftCatalogServiceProtocol
    
}
