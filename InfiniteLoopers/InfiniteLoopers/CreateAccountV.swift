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
    
    
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameCheckedImage: UIImageView!
    @IBOutlet weak var emailCheckedImage: UIImageView!
    @IBOutlet weak var passwordCheckedImage: UIImageView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var createAccountButtonBottomConstraint: NSLayoutConstraint!
    
    convenience init(model:CreateAccountVMProtocol){
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
}

// MARK: - UIViewController


extension CreateAccountV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupButtons()
        
    }
    
    func setupTextFields(){
        userNameTF.becomeFirstResponder()
        let isUserNameCheckHidden = Variable(true)
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
        
        isUserNameCheckHidden.asObservable().bindTo(userNameCheckedImage.rx.isHidden).addDisposableTo(disposeBag)
        isEmailCheckHidden.asObservable().bindTo(emailCheckedImage.rx.isHidden).addDisposableTo(disposeBag)
        isPasswordCheckHidden.asObservable().bindTo(passwordCheckedImage.rx.isHidden).addDisposableTo(disposeBag)
        
        userNameTF
            .rx.text
            .debounce(0.3, scheduler: MainScheduler.instance)
            .filterNil()
            .subscribe(onNext: {[unowned self] text in
                if(text.characters.count > 3){
                    self.model.check(nickName: text)
                        .catchError(){error in
                            return .just(false)
                        }
                        .map{!$0}
                        .distinctUntilChanged()
                        .bindTo(isUserNameCheckHidden)
                        .addDisposableTo(self.disposeBag)
                }else{
                    isUserNameCheckHidden.value = true
                }
            }).addDisposableTo(disposeBag)
        
        Observable.combineLatest(isUserNameCheckHidden.asObservable(), isEmailCheckHidden, isPasswordCheckHidden){
            return ($0.0 || $0.1 || $0.2)
            }.distinctUntilChanged().bindTo(createAccountButton.rx.isHidden).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{ notification in
            self.createAccountButtonBottomConstraint.constant = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            
        }).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{ notification in
            self.createAccountButtonBottomConstraint.constant = 0
            
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
        
        createAccountButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){ [weak self] in
                guard let `self` = self else {
                    return
                }
                self.model.signUp(withEmail: self.emailTF.text!, password: self.passwordTF.text!, nickName:self.userNameTF.text!)
                    .subscribe(onError: {error in
                        let error = error as! ClientError
                        MessageBar.showError(message: error.errorDescription)
                    },onCompleted: {
                        self.dismiss(animated: true, completion: nil)
                    }).addDisposableTo(self.disposeBag)
            }
            .addDisposableTo(disposeBag)
    }
}
