import UIKit

protocol ProfileViewContrillerDelegate: AnyObject, LoadingView {
    func updateUI()
}

final class ProfileViewController: UIViewController {
    
    private var presenter: ProfileViewControllerPresenterProtocol? = nil
    
    private lazy var backButton: UIBarButtonItem = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "square.and.pencil", withConfiguration: boldConfig)
        button.action = #selector(editButtonDidTapped)
        button.target = self
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 22)
        return label
    }()
    
    private lazy var linkTextView: UITextView = {
        let link = UITextView()
        link.dataDetectorTypes = .link
        link.translatesAutoresizingMaskIntoConstraints = false
        link.isEditable = false
        link.delegate = self
        link.font = UIFont(name: "SFProText-Regular", size: 15)
        link.textColor = UIColor.ypBlueUniversal
        link.isScrollEnabled = false
        return link
    }()
    
    private lazy var nameStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        stack.axis = .horizontal
        return stack
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableDetailInfo: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    
    init(presenter: ProfileViewControllerPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.delegate = self
        navigationItem.rightBarButtonItem = backButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.ypBlack
        addSubviews()
        presenter?.fetchProfile()
        
        tableDetailInfo.register(ProfileDetailInfoCell.self, forCellReuseIdentifier: ProfileDetailInfoCell.cellID)
    }
    
    private func addSubviews() {
        view.addSubview(nameStack)
        nameStack.addArrangedSubview(avatarImageView)
        nameStack.addArrangedSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(linkTextView)
        view.addSubview(tableDetailInfo)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            nameStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameStack.heightAnchor.constraint(equalToConstant: 70),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: nameStack.bottomAnchor, constant: 20),
            
            linkTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            linkTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            linkTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            linkTextView.heightAnchor.constraint(equalToConstant: 28),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            tableDetailInfo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableDetailInfo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableDetailInfo.topAnchor.constraint(equalTo: linkTextView.bottomAnchor, constant: 40),
            tableDetailInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func editButtonDidTapped() {
        let presenter = EditingProfilePresenter(
            profile: presenter?.profileModelUI,
            profileService: presenter?.profileService
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profileNetworlModel):
                self.presenter?.convertInUIModel(profileNetworkModel: profileNetworlModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        let editingVC = EditingProfileViewController(presenter: presenter)
        present(editingVC, animated: true)
    }
}

extension ProfileViewController: ProfileViewContrillerDelegate {
    func updateUI() {
        guard let profileModelUI = presenter?.profileModelUI else { return }
        avatarImageView.image = UIImage(data: profileModelUI.avatar ?? Data())
        nameLabel.text = profileModelUI.name
        descriptionLabel.text = profileModelUI.description
        linkTextView.text = profileModelUI.website
        tableDetailInfo.reloadData()
    }
}

extension ProfileViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let webVC = WebViewViewController(url: URL)
        navigationController?.pushViewController(webVC, animated: true)
        return false
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            showMyNFT()
        case 1:
            showFavouritesNFT()
        case 2:
            if let url = URL(string: linkTextView.text) {
                let webVC = WebViewViewController(url: url)
                navigationController?.pushViewController(webVC, animated: true)
            }
        default:
            break
        }
    }
    
    private func showMyNFT() {
        guard let presenter else { return }
        let myNFTPresenter = MyNFTPresenter(servicesAssembly: presenter.servicesAssembly,
                                            nftsID: presenter.profileModelUI?.nfts ?? [],
                                            likes: presenter.profileModelUI?.likes ?? [])
        myNFTPresenter.completionHandler = {
            [weak self] likedNfts in
            guard let self else { return }
            self.presenter?.profileModelUI?.likes = likedNfts
            self.updateUI()
        }
        let myNFTViewController = MyNFTViewController(presenter: myNFTPresenter)
        myNFTViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myNFTViewController, animated: true)
    }
    
    private func showFavouritesNFT() {
        guard let presenter else { return }
        let favouritesNFTPresenter = FavouritesNFTPresenter(
            servicesAssembly: presenter.servicesAssembly,
            nftsID: presenter.profileModelUI?.likes ?? []
        )
        favouritesNFTPresenter.completionHandler = {
            [weak self] likedNfts in
            guard let self else { return }
            self.presenter?.profileModelUI?.likes = likedNfts
            self.updateUI()
        }
        let favouritesNFTViewController = FavouritesNFTViewController(presenter: favouritesNFTPresenter)
        favouritesNFTViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(favouritesNFTViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.profileModelUI == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableDetailInfo.dequeueReusableCell(withIdentifier: ProfileDetailInfoCell.cellID, for: indexPath) as? ProfileDetailInfoCell
        else {
            return UITableViewCell()
        }
        var name = ""
        switch indexPath.row {
        case 0: name = "Мои NFT (\(presenter?.profileModelUI?.nfts.count ?? 0))"
        case 1: name = "Избранные NFT (\(presenter?.profileModelUI?.likes.count ?? 0))"
        case 2: name = "О разработчике"
        default:
            break
        }
        cell.configureCell(name: name)
        return cell
    }
}
