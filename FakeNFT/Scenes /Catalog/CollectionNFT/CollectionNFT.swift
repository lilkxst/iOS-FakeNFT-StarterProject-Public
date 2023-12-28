//
//  CollectionNFT.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 13.12.2023.
//

import UIKit

protocol NftCollectionView: AnyObject {
    func setup(name: String, cover: String, author: String, description: String)
    func updateCollection()
    func updateCell(indexPath: IndexPath)
}

final class CollectionNFTViewController: UIViewController {
    
    // MARK: - Properties
    
    private let servicesAssembly: ServicesAssembly
    private var presenter: CollectionPresenterProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceHorizontal = false
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentSize = CGSize(width: view.frame.width, height: 1500)
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()

    let stackViewDescriptionLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .top
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private var authorLable: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var authorButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private var descriptionLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var spacerView: UIView = {
       let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CollectionNFTCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.layer.masksToBounds = true
        return collection
    }()
    
    // MARK: - Init
    
    convenience init(servicesAssembly: ServicesAssembly, collection: NFTCollection?){
        self.init(servicesAssembly: servicesAssembly, presenter: CollectionNFTPresenter(service: servicesAssembly, collection: collection))
    }
    
    init(servicesAssembly: ServicesAssembly, presenter: CollectionPresenterProtocol) {
        self.servicesAssembly = servicesAssembly
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        presenter?.view = self
        presenter?.load()
    }
    
    // MARK: - Functions
    
    func configUI() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        //Обложка Коллекции
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Формируем описание Коллекции
        [nameLabel, authorLable, authorButton, stackViewDescriptionLabel].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
//        contentView.addSubview(stackViewTextLabel)
//        stackViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
//        [stackViewNameLabel, stackViewDescriptionLabel ].forEach{
//            stackViewTextLabel.addArrangedSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        stackViewDescriptionLabel.addArrangedSubview(descriptionLable)
        stackViewDescriptionLabel.addArrangedSubview(spacerView)
        
        //Формируем описание названия Коллекции и автора
//        [nameLabel, stackViewAuthorLabel ].forEach{
//            stackViewNameLabel.addArrangedSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
//
//        [authorLable, authorButton ].forEach{
//            stackViewAuthorLabel.addArrangedSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        //Настраиваем коллекцию
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -103),
            contentView.heightAnchor.constraint(equalToConstant: 1500),
            contentView.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            authorLable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLable.widthAnchor.constraint(equalToConstant: 112),
            authorLable.heightAnchor.constraint(equalToConstant: 18),
            
            authorButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            authorButton.leadingAnchor.constraint(equalTo: authorLable.trailingAnchor, constant: 4),
            authorButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            authorButton.heightAnchor.constraint(equalToConstant: 28),
            
            stackViewDescriptionLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: 0),
            stackViewDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackViewDescriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            collectionView.topAnchor.constraint(equalTo: stackViewDescriptionLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - CollectionView Delegate && DataSource

extension CollectionNFTViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.nfts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        guard let model = presenter?.getModel(for: indexPath ) else { return cell }
        cell.config(with: model)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
}

//MARK: - UITCollectionView FlowLayout

extension CollectionNFTViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
         CGSize(width: 108, height: 192)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: - UITCollectionView FlowLayout

extension CollectionNFTViewController: NftCollectionView {
    
    func updateCell(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    
    func updateCollection() {
        collectionView.reloadData()
    }
    
    func setup(name: String, cover: String, author: String, description: String) {
        imageView.kf.setImage(with: URL(string: cover))
        nameLabel.text = name
        authorButton.setTitle(author, for: .normal)
        authorButton.addTarget(self, action: #selector(didTapAuthor), for: .touchUpInside)
        descriptionLable.text = description
    }
    
    @objc
    func didTapAuthor(){
        //Открываем Webview
    }
}

//MARK: - NftCellDelegate

extension CollectionNFTViewController: NftCellDelegate {
    
    func changeOrder(for indexPath: IndexPath) {
        presenter?.changeOrderState(for: indexPath)
    }
    
    func changeLike(for indexPath: IndexPath, state: Bool) {
        presenter?.changeLikeState(for: indexPath, state: state)
    }
    
}
