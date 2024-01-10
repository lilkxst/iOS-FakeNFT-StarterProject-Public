import Foundation

protocol MyNFTCellPresenterProtocol: AnyObject {
    var view: MyNFTCellView? {get set}
    var delegate: MyNFTViewControllerProtocol? { get set}
    var nft: Nft? {get}
    func loadImage()
    func likeButtonDidTapped()
    func isLiked() -> Bool
}

final class MyNFTCellPresenter: MyNFTCellPresenterProtocol {

    weak var view: MyNFTCellView?
    let servicesAssembly: ServicesAssembly?

    let nft: Nft?
    weak var delegate: MyNFTViewControllerProtocol?

    init(view: MyNFTCellView? = nil,
         nft: Nft?,
         servicesAssembly: ServicesAssembly?) {
        self.view = view
        self.nft = nft
        self.servicesAssembly = servicesAssembly
    }

    func loadImage() {
        guard let url = nft?.images.first else { return }
        view?.showLoading()
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, error in
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
        var likedNftsSet = delegate?.presenter?.likedNft
        if likedNftsSet?.contains(idLikedNFt) ?? false {
            likedNftsSet?.remove(idLikedNFt)
        } else {
            likedNftsSet?.insert(idLikedNFt)
        }
        servicesAssembly?.profileService.saveProfile(
            profileEditing: ProfileModelEditing(likes: Array(likedNftsSet ?? Set()))) { [weak self, likedNftsSet] result in
                guard let self, let likedNftsSet else { return }
                self.view?.enabledLikeButton()
                self.view?.hideLoading()
                switch result {
                case .success:
                    self.delegate?.presenter?.likedNft = likedNftsSet
                    self.delegate?.presenter?.updateData(likesNft: likedNftsSet)
                    self.view?.updateLikeImage()
                case .failure(let error):
                    self.delegate?.showAlert(title: NSLocalizedString("titleAlertError", comment: ""), message: error.localizedDescription)
                }
            }
    }

    func isLiked() -> Bool {
        guard let id = nft?.id, let likedNft = delegate?.presenter?.likedNft else { return false }
        return likedNft.contains(id)
    }

}