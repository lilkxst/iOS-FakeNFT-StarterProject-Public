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
        catalogController.tabBarItem = catalogTabBarItem

        let profileController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        profileController.tabBarItem = profileTabBarItem

        let basketController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        basketController.tabBarItem = basketTabBarItem

        let statisticsController = StatisticsViewController(servicesAssembly: servicesAssembly)
           statisticsController.tabBarItem = statisticsTabBarItem
           let statisticsNavController = UINavigationController(rootViewController: statisticsController)

        viewControllers = [profileController, catalogController, basketController, statisticsNavController]

        view.backgroundColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypBlack

    }

}
