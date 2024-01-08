//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by MARIIA on 04.01.24.
//

import UIKit
import Kingfisher

final class NFTCollectionViewCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()

    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        return btn
    }()

    private var ratingView = RatingView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let basketButton: UIButton = {
        let button = UIButton()
        return button
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
        addSubview(imageView)
        addSubview(ratingView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(basketButton)
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        basketButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            ratingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            basketButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            basketButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            basketButton.widthAnchor.constraint(equalToConstant: 30),
            basketButton.heightAnchor.constraint(equalTo: basketButton.widthAnchor)
        ])
    }

    func configure(with nft: Nft, isLiked: Bool) {

        if let imageUrlString = nft.images.first, let imageUrl = URL(string: imageUrlString) {
            imageView.kf.setImage(with: imageUrl)
        }

        nameLabel.text = nft.name
        priceLabel.text = "Цена: \(nft.price)"
            if let currency = nft.currency {
                priceLabel.text?.append(" \(currency.name)")
            }
        ratingView.setRating(rating: nft.rating)

        likeButton.setImage(isLiked ? UIImage(named: "Favourites") : UIImage(named: "UnFavorites"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

    }

    @objc func likeButtonTapped () {}

}
