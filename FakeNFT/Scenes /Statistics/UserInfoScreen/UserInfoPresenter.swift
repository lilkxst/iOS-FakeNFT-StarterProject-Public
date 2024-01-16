//
//  UserInfoPresenter.swift
//  FakeNFT
//
//  Created by MARIIA on 25.12.23.
//

import Foundation

protocol UserInfoViewProtocol: AnyObject {
    func displayUserInfo(_ user: User)
    func displayError(error: Error)
}

final class UserInfoPresenter {
    weak var view: UserInfoViewProtocol?
    private var networkClient: NetworkClient?
    var userId: String
    var user: User?

    init(networkClient: NetworkClient, userId: String) {
        self.networkClient = networkClient
        self.userId = userId
    }

    func viewDidLoad() {
        fetchUserProfile()
    }

    private func fetchUserProfile() {
           let request = UserProfileRequest(userId: userId)
           if let url = request.endpoint {
           } else {
           }

           networkClient?.send(request: request, type: User.self) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let user):
                       self?.view?.displayUserInfo(user)
                   case .failure(let error):

                       self?.view?.displayError(error: error)
                   }
               }
           }
       }

}
