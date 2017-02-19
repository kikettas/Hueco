//
//  LoginV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainLoginV: UIViewController {
    
    var disposeBag = DisposeBag()
    var model:MainLoginVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    convenience init(model:MainLoginVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
}


// MARK: - UIViewController

extension MainLoginV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    func setupButtons(){
        facebookButton.setBorderAndRadius(color: UIColor.clear.cgColor, width: 0, cornerRadius: 5)
        googleButton.setBorderAndRadius(color: UIColor.clear.cgColor, width: 0, cornerRadius: 5)
        emailButton.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 1, cornerRadius: 5)
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                self.dismiss(animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        goToLoginButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                Navigator.navigateToLogin(from: self.navigationController!, presentationStyle: .overFullScreen, transitionStyle: .partialCurl)
            }
            .addDisposableTo(disposeBag)
        
        emailButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext() {
                Navigator.navigateToCreateAccount(from: self.navigationController!)
            }
            .addDisposableTo(disposeBag)
    }
}



