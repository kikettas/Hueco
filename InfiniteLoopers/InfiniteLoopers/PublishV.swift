//
//  PublishV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class PublishV: UIViewController {
    
    var model:PublishVMProtocol!
    
    convenience init(model:PublishVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("publish", comment: "Publish tab title"), image: UIImage(named: "ic_publish_tab_unselected"), selectedImage: UIImage(named: "ic_publish_tab_selected"))
        self.title = NSLocalizedString("publish", comment: "Publish tab title")
    }
}


// MARK: - UIViewController

extension PublishV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()

        // Do any additional setup after loading the view.
    }
}
