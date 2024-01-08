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
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        return imgView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Favourites"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add"), for: .normal)
        button.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
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
        addSubview(likeButton)
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        basketButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                   imageView.topAnchor.constraint(equalTo: self.topAnchor),
                   imageView.widthAnchor.constraint(equalToConstant: 108),
                   imageView.heightAnchor.constraint(equalToConstant: 108),
                   imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

                   ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                   ratingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                   ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),

                   likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
                   likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),

                   nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8),
                   nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                   nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                   priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
                   priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),

                   basketButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10),
                   basketButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                   basketButton.widthAnchor.constraint(equalToConstant: 30),
                   basketButton.heightAnchor.constraint(equalToConstant: 30)

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

    }

    @objc func likeButtonTapped() {

    }

    @objc func basketButtonTapped() {
    }

}
