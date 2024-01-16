import UIKit

protocol FavouritesNFTCellProtocol: AnyObject, LoadingView {
    func setImage(data: Data)
    func unenabledLikeButton()
    func enabledLikeButton()
}

final class FavouritesNFTCell: UICollectionViewCell, FavouritesNFTCellProtocol {

    static let idCell = "idFavouritesNFTCell"

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.numberOfLines = 2
        return label
    }()

    private lazy var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 15)
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonDidTapped), for: .touchUpInside)
        return button
    }()

    var presenter: FavouritesNFTCellPresenterProtocol?

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }

    func configereCell() {
        addSubviews()

        likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(UIColor.ypRedUniversal, renderingMode: .alwaysOriginal), for: .normal)
        nameLabel.text = presenter?.nft?.name

        ratingView.setStars(with: presenter?.nft?.rating ?? 0)
        priceLabel.text = "\(presenter?.nft?.price ?? 0) ETN"

        presenter?.loadImage()
    }

    private func addSubviews() {
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(activityIndicator)
        contentView.addSubview(likeButton)

        detailInfoStack.addArrangedSubview(nameLabel)
        detailInfoStack.addArrangedSubview(ratingView)
        detailInfoStack.addArrangedSubview(priceLabel)
        contentView.addSubview(detailInfoStack)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),

            activityIndicator.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),

            likeButton.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),

            detailInfoStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            detailInfoStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            detailInfoStack.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),

            ratingView.widthAnchor.constraint(equalToConstant: 68),
            ratingView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    func unenabledLikeButton() {
        likeButton.isEnabled = false
    }

    func enabledLikeButton() {
        likeButton.isEnabled = true
    }

    @objc func likeButtonDidTapped() {
        presenter?.likeButtonDidTapped()
    }

    func setImage(data: Data) {
        iconImageView.image = UIImage(data: data)
    }

}
