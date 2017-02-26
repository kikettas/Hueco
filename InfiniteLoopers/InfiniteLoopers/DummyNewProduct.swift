//
//  DummyNewProduct.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit

class DummyNewProduct:UIViewController{
    
    
    convenience init(){
        self.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("publish", comment: "Publish tab title"), image: UIImage(named: "ic_publish_tab_unselected"), selectedImage: UIImage(named: "ic_publish_tab_selected"))
        self.title = NSLocalizedString("publish", comment: "Publish tab title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
    }
}
