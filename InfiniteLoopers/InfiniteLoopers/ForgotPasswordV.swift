//
//  ForgotPasswordV.swift
//  InfiniteLoopers
//
//  Created by Alma Martinez on 16/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ForgotPasswordV: UIViewController {
    
    var disposeBag = DisposeBag()
    var model:ForgotPasswordVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    
    convenience init(model:ForgotPasswordVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
   
}

//  MARK: - UIViewController

extension ForgotPasswordV{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
