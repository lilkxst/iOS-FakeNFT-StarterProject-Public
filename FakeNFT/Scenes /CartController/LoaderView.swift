//
//  LoaderView.swift
//  FakeNFT
//
//  Created by Артём Костянко on 12.01.24.
//

import UIKit

final class LoaderView: UIView, LoadingView {

    var activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
