
import Foundation

protocol FavouritesNFTPresenterProtocol: AnyObject {
    var servicesAssembly: ServicesAssembly {get}
    var view: FavouritesNFTViewControllerProtocol? { get set }
    var nfts: [Nft] { get }
    var nftsID: Set<String> { get }
    var completionHandler: (([String]) -> ())? { get set }
    func viewDidLoad()
    func removeNftFromLikes(withId id: String)
    func viewWillDisappear()
}

final class FavouritesNFTPresenter: FavouritesNFTPresenterProtocol {
    
    let servicesAssembly: ServicesAssembly
    var nfts: [Nft] = []
    var nftsID: Set<String>
    var completionHandler: (([String]) -> ())?
    weak var view: FavouritesNFTViewControllerProtocol?
    
    init(servicesAssembly: ServicesAssembly, nftsID: [String]) {
        self.servicesAssembly = servicesAssembly
        self.nftsID = Set(nftsID)
    }
    
    func viewDidLoad() {
        if nftsID.count > 0 {
            loadNfts()
        } else {
            view?.showCap()
        }
    }
    
    func viewWillDisappear() {
        completionHandler?(Array(nftsID))
    }
    
    private func loadNfts() {
        view?.showLoading()
        var nftsIDCount = nftsID.count
        var nftsCount = nfts.count
        for id in nftsID {
            servicesAssembly.nftService.loadNft(id: id) { [weak self] result in
                guard let self else { return}
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    nftsCount += 1
                    if nftsIDCount == nftsCount {
                        self.view?.hideLoading()
                        self.nfts.count > 0 ? self.view?.hiddenCap() : self.view?.showCap()
                        self.view?.updateUI()
                    }
                case.failure(let error):
                    nftsIDCount -= 1
                    if nftsIDCount == nftsCount {
                        self.view?.hideLoading()
                        self.nfts.count > 0 ? self.view?.hiddenCap() : self.view?.showCap()
                        self.view?.updateUI()
                    }
                    view?.showAlert(title: "Ошибка при получении NFT по id", message: "По id \(id) не удалось получить NFT  по причине \(error)")
                }
            }
        }
    }
    
    func removeNftFromLikes(withId id: String) {
        for index in 0..<nfts.count {
            if nfts[index].id == id {
                nfts.remove(at: index)
                view?.removeItem(at: index)
                break
            }
        }
        nftsID.remove(id)
    }
    
}
