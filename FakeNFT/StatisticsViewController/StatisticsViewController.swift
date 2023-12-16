import UIKit

final class StatisticsViewController: UIViewController, UsersViewProtocol, UITableViewDataSource, UITableViewDelegate {

    private var activityIndicator: UIActivityIndicatorView!
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
        presenter.view = self
        presenter.setNetworkClient(servicesAssembly.provideNetworkClient())
        setupActivityIndicator()
        activityIndicator.startAnimating()
        presenter.loadUsers()
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    func setupNavigationBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(named: "filterChoseImages")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(filterTapped)
        )
        navigationItem.rightBarButtonItem = filterButton
    }

    private func setupActivityIndicator() {
           activityIndicator = UIActivityIndicatorView(style: .large)
           activityIndicator.center = view.center
           activityIndicator.hidesWhenStopped = true
           view.addSubview(activityIndicator)
       }

    func displayUsers(_ users: [User]) {
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }

        func displayError(_ error: Error) {
            activityIndicator.stopAnimating()
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserCell",
            for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }

        let user = presenter.users[indexPath.row]
        cell.configure(with: user)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectUser(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 88
        }

    @objc func filterTapped() {

        }
}
