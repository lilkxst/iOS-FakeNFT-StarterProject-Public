import UIKit

protocol UsersViewProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func displayError(_ error: Error)
}

final class UsersPresenter {

    weak var view: UsersViewProtocol?
    var networkClient: NetworkClient?
    var users: [User] = []

    func setNetworkClient(_ client: NetworkClient) {
        networkClient = client
    }

    func viewDidLoad() {
        updateView()
    }

    func updateView() {
        view?.displayUsers(users)
    }

    func didSelectUser(at index: Int) {
    }

     func loadUsers() {
         guard let networkClient = networkClient else {
             print("NetworkClient is not set in UsersPresenter")
             return
         }

         let request = UsersRequest()
         networkClient.send(request: request, type: [User].self) { [weak self] result in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let users):
                     self?.users = users.sorted {
                         (Int($0.rating) ?? 0) < (Int($1.rating) ?? 0)
                     }
                     self?.view?.displayUsers(users)
                 case .failure(let error):
                     self?.view?.displayError(error)
                     print("Error: \(error)")
                 }
             }
         }
     }

 }
