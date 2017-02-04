//
//  MainTabBarV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class MainTabBarV: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchTab = SearchV(model:SearchVM())
        let notificationsTab = NotificationsV(model:NotificationsVM())
        let publishTab = PublishV(model: PublishVM())
        let sharedTab = SharedV(model:SharedVM())
        let profileTab = ProfileV(model:ProfileVM())
        
        self.viewControllers = [searchTab, notificationsTab, publishTab, sharedTab, profileTab]
    }
}
