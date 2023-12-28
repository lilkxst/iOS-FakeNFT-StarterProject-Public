import Foundation

protocol UsersViewProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func displayError(_ error: Error)
}

protocol UsersPresenterProtocol: AnyObject {
    var users: [User] { get set }
    var view: UsersViewProtocol? { get set }
    var onUserSelected: ((User) -> Void)? { get set }

    func setNetworkClient(_ client: NetworkClient)
    func loadUsers()
    func didSelectUser(at index: Int)
    func changeSortType(_ sortType: SortType)
}

enum SortType {
    case rating
    case alphabetical
}

final class UsersPresenter: UsersPresenterProtocol {

    private var networkClient: NetworkClient?
    weak var view: UsersViewProtocol?
    var users: [User] = []
    var sortType: SortType = .rating
    var onUserSelected: ((User) -> Void)?

    init(servicesAssembly: ServicesAssembly) {
         self.networkClient = servicesAssembly.provideNetworkClient()
     }

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
           guard index < users.count else { return }
           let user = users[index]
           onUserSelected?(user)
       }

    func loadUsers() {
        guard let networkClient = networkClient else {
            print("NetworkClient is not set in UsersPresenter")
            return
        }

        let request = UsersRequest()
        networkClient.send(request: request, type: [User].self) { [weak self] result in
            DispatchQueue.global(qos: .userInitiated).async {
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.sortUsers()
                    DispatchQueue.main.async {
                        if let sortedUsers = self?.users {
                            self?.view?.displayUsers(sortedUsers)
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.view?.displayError(error)
                        print("Error: \(error)")
                    }
                }
            }
        }
    }

    func changeSortType(_ sortType: SortType) {
        self.sortType = sortType
        sortUsers()
        view?.displayUsers(users)
    }

    private func sortUsers() {
        switch sortType {
        case .rating:
            users.sort { (Int($0.rating) ?? 0) > (Int($1.rating) ?? 0) }
        case .alphabetical:
            users.sort { $0.name < $1.name }
        }
    }

}
