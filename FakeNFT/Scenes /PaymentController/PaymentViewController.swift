//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import UIKit

protocol PaymentViewControllerProtocol: AnyObject {
    func updateCurrencyList()
    func didSelectCurrency(isEnable: Bool)
    func didPayment(paymentResult: Bool)
    func startLoadIndicator()
    func stopLoadIndicator()
}

final class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    
    private var presenter: PaymentPresenterProtocol?
    private let termsUrl = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var currencyList: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colletionView.backgroundColor = .ypWhite
        colletionView.allowsMultipleSelection = false
        return colletionView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var termsTextView: UITextView = {
        let textView = UITextView()
        
        let attributedString = NSMutableAttributedString(string: "Совершая покупку, вы соглашаетесь с условиями" + " " + "Пользовательского соглашения")
        

        let startPosition = "Совершая покупку, вы соглашаетесь с условиями".count + 1
        let lenOfLink = "Пользовательского соглашения".count
        attributedString.setAttributes([.font: UIFont.caption2], range: NSMakeRange(0, attributedString.length))
        attributedString.setAttributes([.link: termsUrl], range: NSMakeRange(startPosition, lenOfLink))

        textView.backgroundColor = .clear
        textView.attributedText = attributedString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.linkTextAttributes = [
            .foregroundColor: UIColor.ypBlueUniversal,
            .font: UIFont.caption2
        ]
        
        textView.delegate = self
        return textView
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.setTitle(NSLocalizedString("PaymentController.pay", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        return button
    }()
    
    private let loaderView = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PaymentPresenter(paymentController: self, paymentService: servicesAssembly.paymentService, orderService: servicesAssembly.orderService)
        setupViews()
        currencyList.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: "CurrencyCell")
        currencyList.dataSource = self
        currencyList.delegate = self
        presenter?.getCurrencies()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.title = NSLocalizedString("PaymentController.title", comment: "")
        navigationBar.titleTextAttributes = [.font: UIFont.bodyBold]
        navigationBar.tintColor = .ypBlack
        view.addSubview(currencyList)
        view.addSubview(bottomView)
        bottomView.addSubview(termsTextView)
        bottomView.addSubview(paymentButton)
        paymentButton.isEnabled = false
        view.addSubview(loaderView)
        loaderView.constraintCenters(to: view)
        
        NSLayoutConstraint.activate([
            currencyList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyList.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            currencyList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            termsTextView.heightAnchor.constraint(equalToConstant: 44),
            termsTextView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            termsTextView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            termsTextView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            paymentButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -50),
            paymentButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12)
        ])
        
        currencyList.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func didTapPayButton() {
        presenter?.payOrder()
    }
    
    func updateCurrencyList() {
        currencyList.reloadData()
    }
    
    func didSelectCurrency(isEnable: Bool) {
        paymentButton.isEnabled = isEnable
        paymentButton.backgroundColor = isEnable ? .ypBlack : .ypLightGrey
    }
    
    func didPayment(paymentResult: Bool) {
        didSelectCurrency(isEnable: true)
        if paymentResult {
            let successPayController = SuccessPayController()
            successPayController.modalPresentationStyle = .fullScreen
            present(successPayController, animated: true) {
                    self.navigationController?.popViewController(animated: true)
                    self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
            }
        } else {
            showPaymentError()
        }
    }
    
    func startLoadIndicator() {
        loaderView.showLoading()
    }
    
    func stopLoadIndicator() {
        loaderView.hideLoading()
    }
    
    func showPaymentError() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("PaymentAlert.title", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("PaymentAlert.cancel", comment: ""), style: .default) { _ in
            self.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: NSLocalizedString("PaymentAlert.repeat", comment: ""), style: .default) { result in
            self.presenter?.payOrder()
        }
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = presenter?.count() else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCollectionViewCell else { return UICollectionViewCell() }
            guard let model = presenter?.getModel(indexPath: indexPath) else { return cell }
            cell.updateCell(currency: model)
            return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = currencyList.cellForItem(at: indexPath) as? CurrencyCollectionViewCell
        cell?.selectedCell(wasSelected: true)
        didSelectCurrency(isEnable: true)
        presenter?.selectedCurrency = cell?.currency
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = currencyList.cellForItem(at: indexPath) as? CurrencyCollectionViewCell
        cell?.selectedCell(wasSelected: false)
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
    }
}

extension PaymentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let termsOfUseVC = WebViewController(url: termsUrl)
        navigationItem.title = ""
        navigationController?.pushViewController(termsOfUseVC, animated: true)
        return false
    }
}
