//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    private var url: URL?
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        load()
        view.backgroundColor = .ypWhite
    }

    private func setupViews() {
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func load() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/" ) else { return }
        webView.load(URLRequest(url: url))
    }

}
