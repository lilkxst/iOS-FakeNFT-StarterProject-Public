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
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "TabCart"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "tabBarStatImages"),
        tag: 3
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
        guard let servicesAssembly else { return }

        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let navController = UINavigationController(rootViewController: catalogController)
        setNavigationController(controller: navController)
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        
        cartController.tabBarItem = cartTabBarItem

        let profilePresenter = ProfileViewControllerPresenter(servicesAssembly: servicesAssembly)
        let profileController = ProfileViewController(presenter: profilePresenter)
        profileController.tabBarItem = profileTabBarItem

        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        statisticsController.tabBarItem = statisticsTabBarItem

        let navProfileController = UINavigationController(rootViewController: profileController)
        let navStatisticsController = UINavigationController(rootViewController: statisticsController)

        viewControllers = [navProfileController, navController, cartNavigationController, navStatisticsController]
        tabBar.isTranslucent = false
        view.backgroundColor = .ypWhite
        tabBar.barTintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypBlack
    }

    func setNavigationController(controller: UINavigationController) {
        controller.navigationBar.setBackgroundImage(UIImage(), for: .default)
        controller.navigationBar.shadowImage = UIImage()
        controller.navigationBar.isTranslucent = true
        controller.view.backgroundColor = .clear
    }

}
