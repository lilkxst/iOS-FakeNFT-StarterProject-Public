import Foundation

protocol UsersViewProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func displayError(_ error: Error)
}

protocol UsersPresenterProtocol: AnyObject {
    var users: [User] { get set }
    var view: UsersViewProtocol? { get set }
    func setNetworkClient(_ client: NetworkClient)
    func loadUsers()
    func didSelectUser(at index: Int)
}

final class UsersPresenter: UsersPresenterProtocol {
    
    private var networkClient: NetworkClient?
    weak var view: UsersViewProtocol?
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
            switch result {
            case .success(let users):
                DispatchQueue.global(qos: .userInitiated).async {
                    let sortedUsers = users.sorted {
                        (Int($0.rating) ?? 0) < (Int($1.rating) ?? 0)
                    }
                    DispatchQueue.main.async {
                        self?.users = sortedUsers
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
