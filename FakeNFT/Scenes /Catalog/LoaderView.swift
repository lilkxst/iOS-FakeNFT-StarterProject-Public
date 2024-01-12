//
//  LoaderView.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 08.01.2024.
//

import Foundation
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
