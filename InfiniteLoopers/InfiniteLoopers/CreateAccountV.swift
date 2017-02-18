//
//  CreateAccountV.swift
//  InfiniteLoopers
//
//  Created by Alma Martinez on 18/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift
import Swarkn

class CreateAccountV: UIViewController {

    var disposeBag = DisposeBag()
    var model:CreateAccountVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

    convenience init(model:CreateAccountVMProtocol){
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
}

extension CreateAccountV{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
