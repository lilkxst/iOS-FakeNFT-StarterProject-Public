//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by MARIIA on 04.01.24.
//

import UIKit
import Kingfisher

final class NFTCollectionViewCell: UICollectionViewCell {

    var nftId: String?
    weak var presenter: UserCollectionPresenterProtocol?

    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        return imgView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "UnFavorites"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add"), for: .normal)
        button.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        return button
    }()

    private var ratingView = RatingView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(ratingView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(basketButton)
        basketButton.isUserInteractionEnabled = true
        likeButton.isUserInteractionEnabled = true
        bringSubviewToFront(basketButton)
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        basketButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.widthAnchor.constraint(equalToConstant: 68),
            ratingView.heightAnchor.constraint(equalToConstant: 12),

            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            basketButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor),
            basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basketButton.widthAnchor.constraint(equalToConstant: 40),
            basketButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with nft: Nft, isLiked: Bool, isInCart: Bool, presenter: UserCollectionPresenterProtocol?) {

        self.presenter = presenter
        self.nftId = nft.id

        if let imageUrl = nft.images.first {
                imageView.kf.setImage(with: imageUrl)
            }
        let isLiked = presenter?.isNftLiked(nft.id) ?? false
            let likeImageName = isLiked ? "Favourites" : "UnFavorites"
            likeButton.setImage(UIImage(named: likeImageName), for: .normal)

        let basketImageName = isInCart ? "Delete" : "Add"
        basketButton.setImage(UIImage(named: basketImageName), for: .normal)
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETN"
        ratingView.setRating(rating: nft.rating)

    }

    @objc private func likeButtonTapped() {
        guard let nftId = nftId else { return }
        likeButton.isEnabled = false
        presenter?.toggleLikeStatus(for: nftId) {
            self.likeButton.isEnabled = true
        }
    }

    @objc private func basketButtonTapped() {
        guard let nftId = nftId else { return }
        basketButton.isEnabled = false
        presenter?.toggleCartStatus(for: nftId) {
            self.basketButton.isEnabled = true
        }
    }
}
