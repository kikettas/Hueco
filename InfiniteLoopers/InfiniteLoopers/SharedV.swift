//
//  SharedV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class SharedV: UIViewController {
    
    var model:SharedVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    convenience init(model:SharedVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: "Shared", image: UIImage.init(color: UIColor.blue), selectedImage: UIImage.init(color: UIColor.blue))
    }
}
