//
//  RatingView.swift
//  FakeNFT
//
//  Created by Артём Костянко on 13.12.23.
//

import UIKit

final class RatingView: UIView {
    
    private lazy var starImage: UIImageView = {
        let starImage = UIImageView()
        starImage.backgroundColor = .clear
        return starImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(starImage)
        
        NSLayoutConstraint.activate([
            starImage.topAnchor.constraint(equalTo: topAnchor),
            starImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            starImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            starImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        starImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setRating(rating: Int) {
        switch rating {
        case 1, 2:
            starImage.image = UIImage(named: "ratingOne")
        case 3, 4:
            starImage.image = UIImage(named: "ratingTwo")
        case 5, 6:
            starImage.image = UIImage(named: "ratingThree")
        case 7, 8:
            starImage.image = UIImage(named: "ratingFour")
        case 9, 10: 
            starImage.image = UIImage(named: "ratingFive")
        default:
            starImage.image = UIImage(named: "ratingZero")
        }
    }
}
