//
//  CollectionNFT.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 13.12.2023.
//

import UIKit

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
        view.image = UIImage(named: "Cover Collection")
        view.clipsToBounds = true
        return view
    }()
    
    let stackViewTextLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    let stackViewNameLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private var authorLable: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции ...."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var descriptionLable: UILabel = {
        let label = UILabel()
        label.text = "Персиковый - как облака над закатным солнецм в окенае. В этой коллекции совмещены трогательная нежность и живая игривость сказачных зефирных зверей."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CollectionNFTCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.layer.masksToBounds = true
        return collection
    }()
    
    // MARK: - Init
    
    convenience init(servicesAssembly: ServicesAssembly){
        self.init(servicesAssembly: servicesAssembly, presenter: CollectionNFTPresenter())
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
        contentView.addSubview(stackViewTextLabel)
        stackViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        [stackViewNameLabel, descriptionLable ].forEach{
            stackViewTextLabel.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //Формируем описание названия Коллекции и автора
        [nameLabel, authorLable ].forEach{
            stackViewNameLabel.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            
            stackViewTextLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            stackViewTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackViewTextLabel.heightAnchor.constraint(equalToConstant: 136),
            
            collectionView.topAnchor.constraint(equalTo: stackViewTextLabel.bottomAnchor, constant: 24),
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
        presenter?.collectionCells.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        guard let model = presenter?.collectionCells[indexPath.row] else { return cell }
        cell.config(with: model)
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