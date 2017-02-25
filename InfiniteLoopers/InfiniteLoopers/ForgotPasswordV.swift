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
import Swarkn

class ForgotPasswordV: UIViewController {
    
    var disposeBag = DisposeBag()
    var model:ForgotPasswordVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var checkEmailImage: UIImageView!
    @IBOutlet weak var bottomSubmitButtonConstraint: NSLayoutConstraint!
    
    convenience init(model:ForgotPasswordVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
   
}

//  MARK: - UIViewController

extension ForgotPasswordV{
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
        
        isEmailCheckHidden.asObservable().bindTo(checkEmailImage.rx.isHidden).addDisposableTo(disposeBag)
        isEmailCheckHidden.asObservable().bindTo(submitButton.rx.isHidden).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{ notification in
            self.bottomSubmitButtonConstraint.constant = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            
        }).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{ notification in
            self.bottomSubmitButtonConstraint.constant = 0
            
        }).addDisposableTo(disposeBag)
    }
    
    func setupButtons(){
        
        goBackButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                Navigator.navigateBack(from: self.navigationController!)
            }
            .addDisposableTo(disposeBag)
        
        submitButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[weak self] in
                guard let `self` = self else {
                    return
                }
                self.model.sendResetPasswordTo(email: self.emailTF.text!)
                
            }
            .addDisposableTo(disposeBag)
    }

}
