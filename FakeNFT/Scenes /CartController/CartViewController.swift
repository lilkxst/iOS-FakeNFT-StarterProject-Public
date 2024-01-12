//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.12.23.
//

import UIKit

final class CartViewController: UIViewController, CartViewControllerProtocol {
    
    private var presenter: CartPresenterProtocol?
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
            self.servicesAssembly = servicesAssembly
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var sortButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem()
        sortButton.image = UIImage(named: "sortButton")
        return sortButton
    }()
    
    private lazy var cartTable: UITableView = {
        let cartTable = UITableView()
        cartTable.separatorStyle = .none
        return cartTable
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.font = .bodyBold
        placeholderLabel.text = NSLocalizedString("Cart.emptyCart", comment: "")
        return placeholderLabel
    }()
    
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .ypLightGrey
        bottomView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 12
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bottomView
    }()
    
    private lazy var countNftInCartLabel: UILabel = {
        let countNftInCartLabel = UILabel()
        countNftInCartLabel.font = .caption1
        return countNftInCartLabel
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let totalPriceLabel = UILabel()
        totalPriceLabel.font = .bodyBold
        totalPriceLabel.textColor = .ypGreenUniversal
        totalPriceLabel.text = ""
        return totalPriceLabel
    }()
    
    private lazy var paymentButton: UIButton = {
        let paymentButton = UIButton()
        paymentButton.layer.masksToBounds = true
        paymentButton.layer.cornerRadius = 16
        paymentButton.backgroundColor = .ypBlack
        paymentButton.setTitleColor(.white, for: .normal)
        paymentButton.titleLabel?.font = .bodyBold
        paymentButton.setTitle(NSLocalizedString("Cart.paymentButton", comment: ""), for: .normal)
        paymentButton.addTarget(self, action: #selector(didTapPaymentButton), for: .touchUpInside)
        return paymentButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        presenter = CartPresenter(viewController: self, orderService: servicesAssembly.orderService, nftByIdService: servicesAssembly.nftByIdService)
        cartTable.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        cartTable.delegate = self
        cartTable.dataSource = self
        presenter?.getOrder()
        presenter?.setOrder()
        showPlaceholder()
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let rightButton = UIBarButtonItem(image: UIImage(named: "SortButton"), style: .plain, target: self, action: #selector(didTapSortButton))
        rightButton.tintColor = .ypBlack
        navigationBar.topItem?.setRightBarButton(rightButton, animated: false)
    }
    
    private func setupViews() {
        view.addSubview(cartTable)
        view.addSubview(bottomView)
        bottomView.addSubview(countNftInCartLabel)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(paymentButton)
        view.addSubview(placeholderLabel)
        
        cartTable.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        countNftInCartLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cartTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartTable.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countNftInCartLabel.heightAnchor.constraint(equalToConstant: 20),
            countNftInCartLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            countNftInCartLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22),
            totalPriceLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            totalPriceLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            paymentButton.widthAnchor.constraint(equalToConstant: 240),
            paymentButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            paymentButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showPlaceholder() {
        if presenter?.count() == 0 {
            placeholderLabel.isHidden = false
            bottomView.isHidden = true
        } else {
            setupNavigationBar()
            guard let count = presenter?.count() else { return }
            guard let totalPrice = presenter?.totalPrice() else { return }
            countNftInCartLabel.text = "\(count) NFT"
            totalPriceLabel.text = "\(totalPrice) ETH"
            placeholderLabel.isHidden = true
            bottomView.isHidden = false
            cartTable.reloadData()
        }
    }
    
    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: NSLocalizedString("CartFilter.filter", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("CartFilter.byPrice", comment: ""), style: .default, handler: { [weak self] (UIAlertAction) in
            guard let self = self else { return }
            self.presenter?.sortCart(filter: .price)
            self.cartTable.reloadData()
        } ))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("CartFilter.byRating", comment: ""), style: .default, handler: { [weak self] (UIAlertAction) in
            guard let self = self else { return }
            self.presenter?.sortCart(filter: .rating)
            self.cartTable.reloadData()
        } ))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("CartFilter.byTitle", comment: ""), style: .default, handler: { [weak self] (UIAlertAction) in
            guard let self = self else { return }
            self.presenter?.sortCart(filter: .title)
            self.cartTable.reloadData()
        } ))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("CartFilter.close", comment: ""), style: .cancel, handler: { (UIAlertAction) in
        } ))
        
        self.present(alert, animated: true)
    }
    
    @objc private func didTapPaymentButton() {
        let paymentController = PaymentViewController(servicesAssembly: servicesAssembly)
        paymentController.hidesBottomBarWhenPushed = true
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(paymentController, animated: true)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = presenter?.count() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cartTable.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        guard let model = presenter?.getModel(indexPath: indexPath) else { return cell }
        cell.delegate = self
        cell.updateCell(with: model)
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapDeleteButton(id: String, image: UIImage) {
        let deleteViewController = CartDeleteViewController(servicesAssembly: servicesAssembly, nftImage: image, idForDelete: id)
        deleteViewController.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.present(deleteViewController, animated: true)
    }
}
