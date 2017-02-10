//
//  SharedV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class ChatV: UIViewController {
    
    var model:ChatVMProtocol!

    convenience init(model:ChatVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("chat", comment: "Chat tab title"), image: UIImage(named: "ic_chat_tab_unselected"), selectedImage: UIImage(named: "ic_chat_tab_selected"))
    }
}


// MARK: - UIViewController

extension ChatV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        
        // Do any additional setup after loading the view.
    }
}
