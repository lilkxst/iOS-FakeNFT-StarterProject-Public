//
//  UserInfoPresenter.swift
//  FakeNFT
//
//  Created by MARIIA on 25.12.23.
//

import Foundation

final class UserInfoPresenter {
    weak var view: UserInfoViewProtocol?
    var user: User?

    func viewDidLoad() {
        if let user = user {
            view?.displayUserInfo(user)
        }
    }

    // Дополнительная логика...
}

protocol UserInfoViewProtocol: AnyObject {
    func displayUserInfo(_ user: User)
}
