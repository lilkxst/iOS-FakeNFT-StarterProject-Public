//
//  SuccessPayController.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import UIKit

final class SuccessPayController: UIViewController {
    
    private lazy var successImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "SuccessImage")
        return image
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.headline3
        textLabel.text = NSLocalizedString("SuccessPaymentController.text", comment: "")
        return textLabel
    }()
    
    private lazy var catalogButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlack
        button.setTitle(NSLocalizedString("SuccessPaymentController.catalogButton", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapCatalogButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(successImage)
        view.addSubview(textLabel)
        view.addSubview(catalogButton)
        
        NSLayoutConstraint.activate([
            successImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImage.widthAnchor.constraint(equalToConstant: 278),
            successImage.heightAnchor.constraint(equalToConstant: 278),
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor,constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            
            catalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            catalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             catalogButton.heightAnchor.constraint(equalToConstant: 60),
            catalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapCatalogButton() {
        self.dismiss(animated: true)
    }
}
