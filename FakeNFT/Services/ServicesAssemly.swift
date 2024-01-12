final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorageProtocol
    private let catalogStorage: CatalogStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorageProtocol,
        catalogStorage: CatalogStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
        self.catalogStorage = catalogStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    func provideNetworkClient() -> NetworkClient {
           return networkClient
       }

    var profileService: ProfileServiceProtocol {
        ProfileNetworkService(
            networkClient: networkClient,
            profileStorage: profileStorage
        )
    }

    var nftCatalogService: NftCatalogServiceProtocol {
        NftCatalogService(
            networkClient: networkClient,
            storage: catalogStorage
        )
    }

}
