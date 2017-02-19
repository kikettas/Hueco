//
//  LoginV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/12/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Swarkn

class LoginV: UIViewController {
    
    var disposeBag = DisposeBag()
    var model:LoginVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailCheck: UIImageView!
    @IBOutlet weak var passwordCheck: UIImageView!
    @IBOutlet weak var goToForgotPasswordButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    convenience init(model:LoginVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
}

// MARK: - UIViewController

extension LoginV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupButtons()
    }
    
    func setupTextFields(){
        emailTF.becomeFirstResponder()
        let isEmailCheckHidden = emailTF
            .rx
            .text
            .observeOn(MainScheduler.instance)
            .shareReplay(1)
            .map{!Validation.Email.isEmailValid(email: $0!)}
            .distinctUntilChanged()
        
        let isPasswordCheckHidden = passwordTF
            .rx
            .text
            .observeOn(MainScheduler.instance)
            .shareReplay(1)
            .map{($0?.characters.count)! < 6}
            .distinctUntilChanged()
        
        isEmailCheckHidden.asObservable().bindTo(emailCheck.rx.isHidden).addDisposableTo(disposeBag)
        isPasswordCheckHidden.asObservable().bindTo(passwordCheck.rx.isHidden).addDisposableTo(disposeBag)
        
        Observable.combineLatest(isEmailCheckHidden, isPasswordCheckHidden){
                return ($0.0 || $0.1)
        }.distinctUntilChanged().bindTo(loginButton.rx.isHidden).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{ notification in
            self.loginButtonBottomConstraint.constant = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
            
        }).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{ notification in
            self.loginButtonBottomConstraint.constant = 0
            
        }).addDisposableTo(disposeBag)
    }
    
    func setupButtons(){
        goToForgotPasswordButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                print("Go to forgot password")
                Navigator.navigateToForgotPassword(from: self.navigationController!)
            }
            .addDisposableTo(disposeBag)
        
        goBackButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                self.navigationController?.popViewController(animated: true)
            }
            .addDisposableTo(disposeBag)
        
        

    }
}
