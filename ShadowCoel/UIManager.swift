//
//  UIManager.swift
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import ShadowCoelLibrary
import Aspects

class UIManager: NSObject, AppLifeCycleProtocol {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIView.appearance().tintColor = Color.Brand
        
        UITableView.appearance().backgroundColor = Color.Background
        UITableView.appearance().separatorColor = Color.Separator
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor :Color.NavigationText]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Color.NavigationBackground

        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = Color.TabBackground
        UITabBar.appearance().tintColor = Color.TabItemSelected

        keyWindow?.rootViewController = makeRootViewController()
        
        Receipt.shared.validate()
        return true
    }
    
    func makeRootViewController() -> UITabBarController {
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = makeChildViewControllers()
        tabBarVC.selectedIndex = 0
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.barTintColor = Color.TabBackground
        return tabBarVC
    }
    
    func makeChildViewControllers() -> [UIViewController] {
//        let cons: [(UIViewController.Type, String, String)] = [(HomeVC.self, "Home".localized(), "Home"), (DashboardVC.self, "Statistics".localized(), "Dashboard"), (CollectionViewController.self, "Manage".localized(), "Config"), (SettingsViewController.self, "More".localized(), "More"),(SimpleVC.self, "Simple".localized(), "Dashboard")]
        let cons: [(UIViewController.Type, String, String)] = [(SimpleVC.self, "Simple".localized(), "Dashboard")]
        return cons.map {
            let vc = UINavigationController(rootViewController: $0.init())
            vc.tabBarItem = UITabBarItem(title: $1, image: $2.originalImage, selectedImage: $2.templateImage)   
            return vc
        }
    }
    
    func setColor() {
        UIView.appearance().tintColor = Color.Brand
        UITableView.appearance().backgroundColor = Color.Background
        UITableView.appearance().separatorColor = Color.Separator
        UINavigationBar.appearance().barTintColor = Color.NavigationBackground
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor :Color.NavigationText]
        UITabBar.appearance().tintColor = Color.TabItemSelected
    }
    
    func reloadAll() {
        setColor()
        if let window = keyWindow {
            window.subviews.forEach({ (view: UIView) in
                view.removeFromSuperview()
                window.addSubview(view)
            })
        }
    }
    
}
