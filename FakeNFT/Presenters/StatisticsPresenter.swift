import UIKit

class UsersPresenter {
    weak var view: StatisticsViewController?
    var users: [User] = []

    func viewDidLoad() {
        updateView()
    }

    func updateView() {
        view?.tableView.reloadData()
    }

    func didSelectUser(at index: Int) {
    }
}

