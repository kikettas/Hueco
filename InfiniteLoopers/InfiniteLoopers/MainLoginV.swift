//
//  LoginV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import GoogleSignIn
import RxCocoa
import RxSwift
import Swarkn

final class MainLoginV: UIViewController, GIDSignInUIDelegate {
    
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
        facebookButton.setBorderAndRadius(color: UIColor.clear, width: 0, cornerRadius: 5)
        googleButton.setBorderAndRadius(color: UIColor.clear, width: 0, cornerRadius: 5)
        emailButton.setBorderAndRadius(color: UIColor.mainDarkGrey, width: 1, cornerRadius: 5)
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[unowned self] in
                self.dismiss(animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        goToLoginButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[unowned self] in
                Navigator.navigateToLogin(from: self.navigationController!, presentationStyle: .overFullScreen, transitionStyle: .partialCurl)
            }
            .addDisposableTo(disposeBag)
        
        emailButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext() { [unowned self] in
                Navigator.navigateToCreateAccount(from: self.navigationController!)
            }
            .addDisposableTo(disposeBag)
        
        googleButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext() { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.model.loginWithGoogle(from: self){(user, error) in
                    if let error = error{
                        MessageBar.showError(message: error.errorDescription)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .addDisposableTo(disposeBag)
        
        facebookButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[weak self] in
                guard let `self` = self else {
                    return
                }
                self.model.loginWithFacebook(from: self){(user, error) in
                    if let error = error{
                        MessageBar.showError(message: error.errorDescription)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .addDisposableTo(disposeBag)
    }
}



