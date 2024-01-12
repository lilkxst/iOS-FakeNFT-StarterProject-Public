//
//  WebView.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 05.01.2024.
//

import UIKit
import WebKit

final class WebView: UIViewController {

    private var url: URL?
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
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
        configUI()
        load()
        view.backgroundColor = .ypWhite
    }

    private func configUI() {
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }

    private func load() {
        // Добавил моковый адресс, т.к. адрес автора в ячейках не рабочий
        guard let url = URL(string: "https://practicum.yandex.ru" ) else { return }
        webView.load(URLRequest(url: url))
    }

}
