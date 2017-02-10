//
//  ProfileV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class ProfileV: UIViewController {

    var model:ProfileVMProtocol!
    
    convenience init(model:ProfileVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("me", comment: "Profile tab title"), image: UIImage(named: "ic_profile_tab_unselected"), selectedImage: UIImage(named: "ic_profile_tab_selected"))
        self.title = NSLocalizedString("profile", comment: "Profile view title")
    }
}


// MARK: - UIViewController

extension ProfileV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()

        // Do any additional setup after loading the view.
    }
}
