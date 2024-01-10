import UIKit

final class TabBarController: UITabBarController {

    private var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "Profile"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profil", comment: ""),
        image: UIImage(systemName: "person.circle.fill"),
        tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "tabBarStatImages"),
        tag: 3
    )

    private let basketTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.basket", comment: ""),
        image: UIImage(named: "Basket"),
        tag: 2
    )

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let servicesAssembly = servicesAssembly else { return }

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let profilePresenter = ProfileViewControllerPresenter(servicesAssembly: servicesAssembly)
        let profileController = ProfileViewController(presenter: profilePresenter)
        let navigationController1 = UINavigationController(rootViewController: profileController)
        
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem

        let basketController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let statisticsController = StatisticsViewController(servicesAssembly: servicesAssembly)
        let statisticsNavController = UINavigationController(rootViewController: statisticsController)

        viewControllers = [navigationController1, profileController, catalogController, basketController, statisticsNavController]
        view.backgroundColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypBlack
        viewControllers = [navigationController1, catalogController]

    }

}
