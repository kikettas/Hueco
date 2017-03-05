//
//  MainTabBarV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class MainTabBarV: UITabBarController, UITabBarControllerDelegate {

    var model:MainTabBarVMProtocol!
    
    convenience init(model:MainTabBarVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }

}

// MARK: - UITabBarController

extension MainTabBarV{
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBar()
        setupViewControllers()
    }
    
    func setupTabBar(){
        self.tabBar.tintColor = UIColor.mainRed
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
    }
    
    func setupViewControllers(){
        let searchTab = SearchV(model:SearchVM())
        let notificationsTab = NotificationsV(model:NotificationsVM())
        let chatsTab = ChatsV(model:ChatsVM())
        let profileTab = ProfileV(model:ProfileVM())
        
        self.viewControllers = [UINavigationController(rootViewController: searchTab), UINavigationController(rootViewController: notificationsTab), UINavigationController(rootViewController: DummyNewProduct()), UINavigationController(rootViewController: chatsTab), UINavigationController(rootViewController: profileTab)]
    }
}

// MARK: - UITabBarDelegate

extension MainTabBarV{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(self.tabBar.items?[2] == item){
            Navigator.navigateToNewProduct(from: self)
        }else if (self.tabBar.items?[4] == item && AppManager.shared.userLogged.value == nil){
            Navigator.navigateToMainLogin(from: self, presentationStyle: .overFullScreen, transitionStyle: .coverVertical)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if(viewController == tabBarController.viewControllers?[2]){
            return false
        }
        
        if (viewController == tabBarController.viewControllers?[4] && AppManager.shared.userLogged.value == nil){
            return false
        }
        
        return true
    }
}
