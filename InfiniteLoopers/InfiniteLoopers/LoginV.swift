//
//  LoginV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class LoginV: UIViewController {
    
    var model:LoginVMProtocol!
    
    convenience init(model:LoginVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
}


// MARK: - UIViewController

extension LoginV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundEffect()
        
    }
    func setupBackgroundEffect(){
        self.view.backgroundColor = UIColor.mainRedTranslucent
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        
        self.view.addSubview(effectView)
    }
}



