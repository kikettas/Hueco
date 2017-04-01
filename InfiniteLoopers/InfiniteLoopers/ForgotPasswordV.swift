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
    var loadingView:UIView!
    
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
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{[unowned self] notification in
            self.bottomSubmitButtonConstraint.constant = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            
        }).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{[unowned self] notification in
            self.bottomSubmitButtonConstraint.constant = 0
            
        }).addDisposableTo(disposeBag)
    }
    
    func setupButtons(){
        
        goBackButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){[unowned self] in
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
                self.loadingView = self.view.addLoadingView(isBlurred:true)

                self.model.sendResetPasswordTo(email: self.emailTF.text!){[weak self] _ , error in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.loadingView.removeFromSuperview()
                    
                    if let error = error{
                        MessageBar.showError(message: error.errorDescription)
                        return
                    }
                    let emailSentDialog = CustomAlertV(title: nil, message: NSLocalizedString("recover_password_mail_message", comment: "recover_password_mail_message"), positiveMessage: "OK", negativeMessage: nil){_ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    emailSentDialog.modalPresentationStyle = .overFullScreen
                    emailSentDialog.modalTransitionStyle = .crossDissolve
                    self.present(emailSentDialog, animated: true, completion: nil)
                }
                self.view.resignFirstResponder()
                
            }
            .addDisposableTo(disposeBag)
    }

}
