//
//  UserInfoViewController.swift
//  FakeNFT
//
//  Created by MARIIA on 25.12.23.
//

import UIKit
import SafariServices

final class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserInfoViewProtocol {

    private let servicesAssembly: ServicesAssembly
    var user: User?
    var presenter: UserInfoPresenter?

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        return button
    }()

    private lazy var customTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationController?.navigationBar.tintColor = .black
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
        view.addSubview(customTableView)

    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),

            customTableView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 20),
            customTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let nftCount = user?.nfts.count ?? 0
        cell.configure(with: nftCount)

        return cell
    }

    @objc private func websiteButtonTapped() {
        if let urlString = user?.website, let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }

    func displayUserInfo(_ user: User) {
        self.user = user
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        if let imageUrl = URL(string: user.avatar) {
            avatarImageView.kf.setImage(with: imageUrl)
        }
        customTableView.reloadData()
    }

    func displayError(error: Error) {
           let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }

}

extension UserInfoViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCollectionVC = UserCollectionViewController(servicesAssembly: servicesAssembly)
        userCollectionVC.user = self.user
        userCollectionVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userCollectionVC, animated: true)
    }
}
