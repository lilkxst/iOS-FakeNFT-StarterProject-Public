import UIKit

final class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var presenter: UsersPresenter!
    var tableView: UITableView!
    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
           self.servicesAssembly = servicesAssembly
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        presenter = UsersPresenter()
        presenter.setNetworkClient(servicesAssembly.provideNetworkClient())
        presenter.view = self
        presenter.loadUsers()
    }

    func setupTableView() {
        tableView = UITableView(frame: self.view.bounds)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }

    func setupNavigationBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(named: "filterChoseImages"),
            style: .plain,
            target: self,
            action: #selector(filterTapped)
        )
        navigationItem.rightBarButtonItem = filterButton
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = presenter.users[indexPath.row]
        cell.textLabel?.text = "\(user.name) - \(user.description)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectUser(at: indexPath.row)
    }

    @objc func filterTapped() {

        }
}
