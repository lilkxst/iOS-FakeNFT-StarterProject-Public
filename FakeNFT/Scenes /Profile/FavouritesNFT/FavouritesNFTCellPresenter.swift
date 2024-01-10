
import Foundation

protocol FavouritesNFTCellPresenterProtocol: AnyObject {
    var nft: Nft? {get}
    var view: FavouritesNFTCellProtocol? {get}
    var delegate: FavouritesNFTViewControllerProtocol? { get set }
    func loadImage()
    func likeButtonDidTapped()
}

final class FavouritesNFTCellPresenter: FavouritesNFTCellPresenterProtocol {
    
    let nft: Nft?
    weak var view: FavouritesNFTCellProtocol?
    weak var delegate: FavouritesNFTViewControllerProtocol?
    let servicesAssembly: ServicesAssembly?
    
    init(nft: Nft?,
         view: FavouritesNFTCellProtocol?,
         servicesAssembly: ServicesAssembly?)
    {
        self.nft = nft
        self.view = view
        self.servicesAssembly = servicesAssembly
    }
    
    func loadImage() {
        let url = nft?.images.first
        guard let url else { return }
        view?.showLoading()
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.hideLoading()
                self.view?.setImage(data: data)
            }
        }.resume()
    }
    
    func likeButtonDidTapped() {
        view?.unenabledLikeButton()
        view?.showLoading()
        guard let idLikedNFt = nft?.id else { return }
        var likedNftsSet = delegate?.presenter?.nftsID ?? Set()
        likedNftsSet.remove(idLikedNFt)
        servicesAssembly?.profileService.saveProfile(
            profileEditing: ProfileModelEditing(likes: Array(likedNftsSet))) { [weak self] result in
                guard let self else { return }
                self.view?.enabledLikeButton()
                self.view?.hideLoading()
                switch result {
                case .success(_):
                    self.delegate?.presenter?.removeNftFromLikes(withId: idLikedNFt)
                case .failure(let error):
                    self.delegate?.showAlert(title: NSLocalizedString("titleAlertError", comment: ""), message: error.localizedDescription)
                }
            }
    }
}
