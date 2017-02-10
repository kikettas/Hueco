//
//  NotificationsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class NotificationsV: UIViewController {

    var model:NotificationsVMProtocol!
    
    convenience init(model:NotificationsVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("notifications", comment: "Notications tab title"), image: UIImage(named: "ic_notifications_tab_unselected"), selectedImage: UIImage(named: "ic_notifications_tab_selected"))
    }
}


// MARK: - UIViewController

extension NotificationsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()

    }
}
