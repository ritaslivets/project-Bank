//
//  AppCoordinator.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator, AuthModuleOutput, RegisterModuleOutput {
    private let window: UIWindow
    private let tabBarController = UITabBarController()
    
    private let authService: AuthServiceProtocol = AuthService()
    private let profileStorage: ProfileStorageProtocol = ProfileStorage()
    private let networkService: NetworkServiceProtocol = NetworkService()
    private lazy var currencyService: CurrencyServiceProtocol = CurrencyService(networkService: networkService)
    private let pointsService: BankPointsServiceProtocol = BankPointsService()
    
    init(window: UIWindow) {
        self.window = window
        setupAppearance()
    }
    
    func start() {
        if authService.isAuthenticated {
            showMainFlow()
        } else {
            showLogin()
        }
        window.makeKeyAndVisible()
    }
    
    func showLogin() {
        let authVC = AuthViewController()
        let presenter = AuthPresenter(view: authVC, authService: authService, output: self)
        authVC.presenter = presenter
        
        UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = authVC
        })
    }
    
    func showRegistration() {
        let regVC = RegisterViewController()
        let presenter = RegisterPresenter(view: regVC, output: self, profileStorage: profileStorage, authService: authService)
        regVC.presenter = presenter
        
        UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = regVC
        })
    }
    
    // MARK: - AuthModuleOutput & RegisterModuleOutput
    func didFinishAuthentication() {
        showMainFlow()
    }
    
    func didRequestRegistration() {
        showRegistration()
    }
    
    func didFinishRegistration() {
        showMainFlow()
    }
    
    func didRequestLogin() {
        showLogin()
    }
    
    // MARK: - Main Flow
    private func showMainFlow() {
        let dashboardNav = makeDashboardNavigation()
        let ratesNav = makeRatesNavigation()
        let converterNav = makeConverterNavigation()
        let mapNav = makeMapNavigation()
        
        tabBarController.viewControllers = [dashboardNav, ratesNav, converterNav, mapNav]
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = self.tabBarController
        })
    }
    
    private func makeDashboardNavigation() -> UINavigationController {
        let view = DashboardViewController()
        let presenter = DashboardPresenter(view: view, currencyService: currencyService)
        view.presenter = presenter
        
        let nav = UINavigationController(rootViewController: view)
        nav.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        return nav
    }
    
    private func makeRatesNavigation() -> UINavigationController {
        let view = RatesListViewController()
        let presenter = RatesListPresenter(view: view, currencyService: currencyService)
        view.presenter = presenter
        
        let nav = UINavigationController(rootViewController: view)
        nav.tabBarItem = UITabBarItem(title: "Курсы", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis.circle.fill"))
        return nav
    }
    
    private func makeConverterNavigation() -> UINavigationController {
        let view = ConverterViewController()
        let presenter = ConverterPresenter(view: view, currencyService: currencyService)
        view.presenter = presenter
        
        let nav = UINavigationController(rootViewController: view)
        nav.tabBarItem = UITabBarItem(title: "Конвертер", image: UIImage(systemName: "arrow.triangle.2.circlepath"), selectedImage: UIImage(systemName: "arrow.triangle.2.circlepath.circle.fill"))
        return nav
    }
    
    private func makeMapNavigation() -> UINavigationController {
        let view = MapViewController()
        let presenter = MapPresenter(view: view, pointsService: pointsService)
        view.presenter = presenter
        
        let nav = UINavigationController(rootViewController: view)
        nav.tabBarItem = UITabBarItem(title: "Точки", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        return nav
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.tintColor = .systemBlue
    }
}
