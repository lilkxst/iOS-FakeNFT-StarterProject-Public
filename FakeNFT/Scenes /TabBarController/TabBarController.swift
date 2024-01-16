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
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [catalogController, cartNavigationController]

        view.backgroundColor = .systemBackground
    }
}
