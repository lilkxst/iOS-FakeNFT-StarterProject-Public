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
        print("UserInfoPresenter инициализирован с userId: \(userId)")
    }

    func viewDidLoad() {
        print("UserInfoPresenter viewDidLoad called")
        fetchUserProfile()
    }

    private func fetchUserProfile() {
           let request = UserProfileRequest(userId: userId)
           if let url = request.endpoint {
               print("Отправка запроса на URL: \(url.absoluteString)")
           } else {
               print("Ошибка формирования URL запроса")
           }

           networkClient?.send(request: request, type: User.self) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let user):
                       print("Получен ответ: \(user)")
                       self?.view?.displayUserInfo(user)
                   case .failure(let error):
                       print("Ошибка запроса: \(error)")
                       self?.view?.displayError(error: error)
                   }
               }
           }
       }

}
