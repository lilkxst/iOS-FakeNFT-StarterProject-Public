final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let orderStorage: OrderStorage
    private let nftByIdStorage: NftByIdStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        orderStorage: OrderStorage,
        nftByIdStorage: NftByIdStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.orderStorage = orderStorage
        self.nftByIdStorage = nftByIdStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
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
