import UIKit

protocol FavouritesNFTViewControllerProtocol: AnyObject, LoadingView {
    var presenter: FavouritesNFTPresenterProtocol? { get }
    func updateUI()
    func removeItem(at: Int)
    func showCap()
    func hiddenCap()
    func showAlert(title: String, message: String)
}

final class FavouritesNFTViewController: UICollectionViewController, FavouritesNFTViewControllerProtocol {

    var presenter: FavouritesNFTPresenterProtocol?

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "chevron.backward")
        button.action = #selector(goBack)
        button.target = self
        return button
    }()

    private lazy var capLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("FavouritesNFT.CapLabelText", comment: "")
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.isHidden = true
        return label
    }()

    init(presenter: FavouritesNFTPresenterProtocol) {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        self.presenter = presenter
        self.collectionView.collectionViewLayout = layout
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(FavouritesNFTCell.self, forCellWithReuseIdentifier: FavouritesNFTCell.idCell)
        presenter?.view = self

        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.ypBlack
        navigationItem.title = NSLocalizedString("FavouritesNFT.navigationItem.title", comment: "")

        addSubviews()

        presenter?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func updateUI() {
        collectionView.reloadData()
    }

    func removeItem(at row: Int) {
        collectionView.deleteItems(at: [IndexPath(row: row, section: 0)])
    }

    func showCap() {
        capLabel.isHidden = false
    }

    func hiddenCap() {
        capLabel.isHidden = true
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func addSubviews() {
        view.addSubview(capLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            capLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            capLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.nfts.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesNFTCell.idCell, for: indexPath) as? FavouritesNFTCell
        else { return UICollectionViewCell()}
        let presenter = FavouritesNFTCellPresenter(nft: presenter?.nfts[indexPath.row],
                                                   view: cell,
                                                   servicesAssembly: presenter?.servicesAssembly)
        presenter.delegate = self
        cell.presenter = presenter
        cell.configereCell()
        return cell
    }
}

extension FavouritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minimumInteritemSpacing = 7
        let leftInset = 16
        let rightInset = 16
        let width = (Int(collectionView.bounds.width) - minimumInteritemSpacing - leftInset - rightInset) / 2
        return CGSize(width: width, height: 80)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }
}
