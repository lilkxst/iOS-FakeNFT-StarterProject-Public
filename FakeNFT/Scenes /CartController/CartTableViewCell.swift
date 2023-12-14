//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.12.23.
//

import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    
    private lazy var fieldView: UIView = {
        let fieldView = UIView()
        return fieldView
    }()
    
    private lazy var imageNft: UIImageView = {
        let imageNFT = UIImageView()
        imageNFT.layer.masksToBounds = true
        imageNFT.layer.cornerRadius = 12
        return imageNFT
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .bodyBold
        return titleLabel
    }()
    
    private lazy var ratingView: RatingView = {
        let ratingView = RatingView()
        return ratingView
    }()
    
    private lazy var priceTitle: UILabel = {
        let priceTitle = UILabel()
        priceTitle.font = .caption2
        priceTitle.text = NSLocalizedString("CartCell.price", comment: "")
        return priceTitle
    }()
    
    private lazy var priceValue: UILabel = {
        let priceValue = UILabel()
        priceValue.font = .bodyBold
        return priceValue
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "DeleteFromCart"), for: .normal)
        return deleteButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        self.contentView.addSubview(fieldView)
        self.fieldView.addSubview(imageNft)
        self.fieldView.addSubview(titleLabel)
        self.fieldView.addSubview(ratingView)
        self.fieldView.addSubview(priceTitle)
        self.fieldView.addSubview(priceValue)
        self.fieldView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            fieldView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            fieldView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            fieldView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            imageNft.topAnchor.constraint(equalTo: fieldView.topAnchor),
            imageNft.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor),
            imageNft.heightAnchor.constraint(equalToConstant: 108),
            imageNft.widthAnchor.constraint(equalToConstant: 108),
            
            titleLabel.topAnchor.constraint(equalTo: fieldView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageNft.trailingAnchor, constant: 20),
            
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceTitle.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12),
            priceTitle.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceValue.topAnchor.constraint(equalTo: priceTitle.bottomAnchor, constant: 2),
            priceValue.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor)
        ])
        fieldView.translatesAutoresizingMaskIntoConstraints = false
        imageNft.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        priceValue.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateCell(nftTitle: String, nftImage: URL?, nftRating: Int, nftPrice: Float) {
        titleLabel.text = nftTitle
        imageNft.kf.setImage(with: nftImage)
        ratingView.setRating(rating: nftRating)
        priceValue.text = "\(nftPrice) ETH"
    }
}
