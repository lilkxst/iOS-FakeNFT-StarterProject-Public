//
//  UserInfoViewController.swift
//  FakeNFT
//
//  Created by MARIIA on 25.12.23.
//

import UIKit

class UserInfoViewController: UIViewController {
    var user: User?

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()

    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var nftButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Коллекция NFT", for: .normal)
        button.addTarget(self, action: #selector(nftButtonTapped), for: .touchUpInside)

        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button.imageView!.frame.size.width, bottom: 0, right: button.imageView!.frame.size.width)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: button.titleLabel!.frame.size.width + 16, bottom: 0, right: -button.titleLabel!.frame.size.width)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        addSubViews()
        applyConstraints()

        if let user = user {
            nameLabel.text = user.name
            descriptionLabel.text = user.description
            if let imageUrl = URL(string: user.avatar) {
                avatarImageView.kf.setImage(with: imageUrl)
            }
        }

        avatarImageView.layer.cornerRadius = 35
    }

    private func addSubViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(nftButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nftButton.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 10),
            nftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

        ])
    }

    @objc private func websiteButtonTapped() {
        if let urlString = user?.website, let url = URL(string: urlString) {
        }
    }

    @objc private func nftButtonTapped() {
        dismiss(animated: true)
    }

}
