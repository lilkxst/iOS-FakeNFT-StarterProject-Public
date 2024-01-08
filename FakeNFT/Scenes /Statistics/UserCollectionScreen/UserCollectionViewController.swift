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
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 3

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: view.frame.width / 2 - 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter = UserCollectionPresenter(view: self, nftService: servicesAssembly.nftService)
        presenter?.viewDidLoad()
        self.navigationItem.title = "Коллекция NFT"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationController?.navigationBar.tintColor = .black

        if let nfts = user?.nfts {
            presenter?.loadUserNFTs(nfts: nfts, likedNFTs: user?.likes ?? [])
        } else {
            presenter?.viewDidLoad()
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 10
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

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NFTCollectionViewCell",
            for: indexPath) as? NFTCollectionViewCell,
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
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let layout = UICollectionViewFlowLayout()
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension UserCollectionViewController: UserCollectionViewProtocol {
    func displayError(_ error: Error) {
    }

    func refreshUI() {
        collectionView.reloadData()
    }
}

extension UserCollectionViewController {
    func setUserNFTs(_ nfts: [String], likedNFTs: [String]) {

    }
}
