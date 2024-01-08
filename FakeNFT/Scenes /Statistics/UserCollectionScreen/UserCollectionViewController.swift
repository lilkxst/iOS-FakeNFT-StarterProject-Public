//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by MARIIA on 04.01.24.
//

import UIKit

protocol UserCollectionViewProtocol: AnyObject {
    func refreshUI()
    func displayError(_ error: Error)
}

final class UserCollectionViewController: UIViewController {

    private let servicesAssembly: ServicesAssembly
    var presenter: UserCollectionPresenterProtocol?
    var user: User?

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: view.frame.width / 2 - 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserCollectionViewController viewDidLoad вызван")
        print("Пользователь в UserCollectionViewController: \(String(describing: user))")
        setupCollectionView()
        presenter = UsersPresenter(servicesAssembly: servicesAssembly) as? UserCollectionPresenterProtocol
        presenter?.viewDidLoad()
        self.navigationItem.title = "Коллекция NFT"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationController?.navigationBar.tintColor = .black

        if let nfts = user?.nfts {
            print("Вызов loadUserNFTs с NFTs: \(nfts)")
            presenter?.loadUserNFTs(nfts: nfts, likedNFTs: user?.likes ?? [])
        } else {
            presenter?.viewDidLoad()
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension UserCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionViewCell", for: indexPath) as? NFTCollectionViewCell,
              let nft = presenter?.item(at: indexPath.row) else {
            return UICollectionViewCell()
        }

        let isLiked = user?.likes?.contains(nft.id) ?? false
        cell.configure(with: nft, isLiked: isLiked)
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
}

extension UserCollectionViewController: UserCollectionViewProtocol {
    func displayError(_ error: Error) {
        print("Ошибка в UserCollectionViewController: \(error)")
    }

    func refreshUI() {
        print("Обновление интерфейса UserCollectionViewController")
        collectionView.reloadData()
    }
}

extension UserCollectionViewController {
    func setUserNFTs(_ nfts: [String], likedNFTs: [String]) {

    }
}
