//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.12.23.
//

import UIKit

final class CartViewController: UIViewController, CartViewControllerProtocol {
    
    private var presenter: CartPresenter?
    
    private lazy var cartTable: UITableView = {
        let cartTable = UITableView()
        cartTable.separatorStyle = .none
        return cartTable
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.font = .bodyBold
        placeholderLabel.text = "Корзина пуста"
        return placeholderLabel
    }()
    
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        //bottomView.backgroundColor = .yaLightGrayLight
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
        totalPriceLabel.textColor = .green
        return totalPriceLabel
    }()
    
    private lazy var paymentButton: UIButton = {
        let paymentButton = UIButton()
        paymentButton.layer.masksToBounds = true
        paymentButton.layer.cornerRadius = 16
        paymentButton.backgroundColor = .black
        paymentButton.setTitleColor(.white, for: .normal)
        paymentButton.titleLabel?.font = .bodyBold
        paymentButton.setTitle("К оплате", for: .normal)
        return paymentButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CartPresenter(viewController: self)
        cartTable.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        cartTable.delegate = self
        cartTable.dataSource = self
    }
    
    private func setupViews() {
        view.addSubview(cartTable)
        view.addSubview(bottomView)
        bottomView.addSubview(countNftInCartLabel)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(paymentButton)
        view.addSubview(placeholderLabel)
        
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
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = presenter?.cartContent.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cartTable.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    
}
