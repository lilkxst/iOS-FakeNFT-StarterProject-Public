final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorageProtocol
    private let catalogStorage: CatalogStorageProtocol
    private let orderStorage: OrderStorage
    private let nftByIdStorage: NftByIdStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorageProtocol,
        catalogStorage: CatalogStorageProtocol,
        orderStorage: OrderStorage,
        nftByIdStorage: NftByIdStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
        self.catalogStorage = catalogStorage
        self.orderStorage = orderStorage
        self.nftByIdStorage = nftByIdStorage
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
    
    var orderService: OrderService {
        OrderServiceImpl(
            networkClietn: networkClient,
            orderStorage: orderStorage,
            nftByIdService: nftByIdService,
            nftStorage: nftByIdStorage)
    }
    
    var nftByIdService: NftByIdService {
        NftByIdServiceImpl(
            networkClient: networkClient,
            storage: nftByIdStorage)
    }
    
    var paymentService: PaymentService {
        PaymentServiceImpl(
            networkClient: networkClient)
    }
}
