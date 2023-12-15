import UIKit

 final class UsersPresenter {

    weak var view: StatisticsViewController?
     var networkClient: NetworkClient?

    var users: [User] = []

     func setNetworkClient(_ client: NetworkClient) {
             networkClient = client
         }

    func viewDidLoad() {
        updateView()
    }

    func updateView() {
        view?.tableView.reloadData()
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
                     self?.view?.tableView.reloadData()
                 case .failure(let error):
                     print("Error: \(error)")
                 }
             }
         }
     }

 }
