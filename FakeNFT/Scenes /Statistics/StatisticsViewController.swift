import UIKit

final class StatisticsViewController: UIViewController, UsersViewProtocol {
    
    private var activityIndicator: UIActivityIndicatorView?
    var presenter: UsersPresenterProtocol?
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter = UsersPresenter()
        presenter?.view = self
        presenter?.setNetworkClient(servicesAssembly.provideNetworkClient())
        setupActivityIndicator()
        activityIndicator?.startAnimating()
        presenter?.loadUsers()
        addSubViews()
        applyConstraints()
    }
    
    func addSubViews() {
        view.addSubview(tableView)
        if let activityIndicator = activityIndicator {
            view.addSubview(activityIndicator)
        }
    }
    
    func applyConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.tableViewTopInset),
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
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    func displayUsers(_ users: [User]) {
        activityIndicator?.stopAnimating()
        tableView.reloadData()
    }
    
    func displayError(_ error: Error) {
        activityIndicator?.stopAnimating()
        showErrorAlert(message: error.localizedDescription)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultCellHeight
    }
    
    @objc private func filterTapped() {
        let alertController = UIAlertController(title: nil, message: "Выберите способ сортировки", preferredStyle: .actionSheet)
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter?.changeSortType(.rating)
        }
        
        let sortAlphabeticallyAction = UIAlertAction(title: "По алфавиту", style: .default) { [weak self] _ in
            self?.presenter?.changeSortType(.alphabetical)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(sortByRatingAction)
        alertController.addAction(sortAlphabeticallyAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectUser(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        if let user = presenter?.users[indexPath.row] {
            cell.configure(with: user, index: indexPath.row)
        }
        return cell
    }
    
}

private extension StatisticsViewController {
    enum Constants {
        static let defaultCellHeight: CGFloat = 88.0
        static let tableViewTopInset: CGFloat = 20.0
    }
}
