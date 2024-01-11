//
//  CartDeleteViewController.swift
//  FakeNFT
//
//  Created by Артём Костянко on 3.01.24.
//

import UIKit

protocol CartDeleteControllerProtocol: AnyObject {
    func showNetworkError(message: String)
}

final class CartDeleteViewController: UIViewController, CartDeleteControllerProtocol {
    
    private var presenter: CartDeletePresenterProtocol?
    private let servicesAssembly: ServicesAssembly
    private (set) var nftImage: UIImage
    private var idForDelete: String
    
    init(servicesAssembly: ServicesAssembly, nftImage: UIImage, idForDelete: String) {
        self.servicesAssembly = servicesAssembly
        self.nftImage = nftImage
        self.idForDelete = idForDelete
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fieldView: UIView = {
        let field = UIView()
        return field
    }()
    
    private lazy var nftImageView: UIImageView = {
        let nftImage = UIImageView()
        nftImage.layer.masksToBounds = true
        nftImage.layer.cornerRadius = 12
        nftImage.image = self.nftImage
        return nftImage
    }()
    
    private lazy var questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.text = NSLocalizedString("CartDelete.questionLabel", comment: "")
        questionLabel.font = .bodyRegular
        questionLabel.numberOfLines = 2
        questionLabel.textAlignment = .center
        return questionLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle(NSLocalizedString("CartDelete.deleteButton", comment: ""), for: .normal)
        deleteButton.setTitleColor(.ypRedUniversal, for: .normal)
        deleteButton.backgroundColor = .ypBlack
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 12
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var returnButton: UIButton = {
        let returnButton = UIButton()
        returnButton.setTitle(NSLocalizedString("CartDelete.returnButton", comment: ""), for: .normal)
        returnButton.backgroundColor = .ypBlack
        returnButton.layer.masksToBounds = true
        returnButton.layer.cornerRadius = 12
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        return returnButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CartDeletePresenter(viewController: self, orderService: servicesAssembly.orderService, nftIdForDelete: idForDelete, nftImage: nftImage)
        setupViews()
    }
    
    private func setupViews() {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        
        view.addSubview(blurView)
        view.addSubview(fieldView)
        view.addSubview(nftImageView)
        view.addSubview(questionLabel)
        view.addSubview(deleteButton)
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            fieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldView.heightAnchor.constraint(equalToConstant: 220),
            fieldView.widthAnchor.constraint(equalToConstant: 262),
            fieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.centerXAnchor.constraint(equalTo: fieldView.centerXAnchor),
            nftImageView.topAnchor.constraint(equalTo: fieldView.topAnchor),
            
            questionLabel.centerXAnchor.constraint(equalTo: fieldView.centerXAnchor),
            questionLabel.widthAnchor.constraint(equalToConstant: 260),
            questionLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            
            returnButton.heightAnchor.constraint(equalToConstant: 44),
            returnButton.widthAnchor.constraint(equalToConstant: 127),
            returnButton.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor),
            returnButton.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor)
        ])
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        fieldView.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapReturnButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDeleteButton() {
        presenter?.deleteNftFromCart { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.dismiss(animated: true)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func showNetworkError(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Alert.title", comment: ""), message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Alert.again", comment: ""), style: .default) { _ in
            self.presenter?.deleteNftFromCart { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.dismiss(animated: true)
                case let .failure(error):
                    print (error)
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Alert.cancel", comment: ""), style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
}
