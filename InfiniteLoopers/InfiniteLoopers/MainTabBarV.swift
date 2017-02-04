//
//  MainTabBarV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class MainTabBarV: UITabBarController {

    var model:MainTabBarVMProtocol!
    
    convenience init(model:MainTabBarVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }

}

// MARK: - UIViewController

extension MainTabBarV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers(){
        let searchTab = SearchV(model:SearchVM())
        let notificationsTab = NotificationsV(model:NotificationsVM())
        let publishTab = PublishV(model: PublishVM())
        let sharedTab = SharedV(model:SharedVM())
        let profileTab = ProfileV(model:ProfileVM())
        
        self.viewControllers = [UINavigationController(rootViewController: searchTab), UINavigationController(rootViewController: notificationsTab), UINavigationController(rootViewController: publishTab), UINavigationController(rootViewController: sharedTab), UINavigationController(rootViewController: profileTab)]
    }
}
