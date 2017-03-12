//
//  NewProductFirstStepV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewProductFirstStepV: UIViewController {
    
    var disposeBag:DisposeBag!
    var model:NewProductFirstStepVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationLabelBottomConstraint: NSLayoutConstraint!
    
    convenience init(model:NewProductFirstStepVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.disposeBag = DisposeBag()
    }
}

// MARK: - UIViewController

extension NewProductFirstStepV{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nextButton
            .rx
            .tap.observeOn(MainScheduler.instance)
            .bindNext {[unowned self] in
                (self.parent as! NewProductPagingV).model.newProductName = self.productNameTF.text!
                Navigator.navigateToNewProductSecondStep(parent: self.parent as! NewProductPagingV)
            }.addDisposableTo(disposeBag)
        
        closeButton
            .rx
            .tap.observeOn(MainScheduler.instance)
            .bindNext {[unowned self] in
                let parent = self.parent as! NewProductPagingV
                parent.dismiss(animated: true, completion: nil)
                
            }.addDisposableTo(disposeBag)
        
        productNameTF
            .rx
            .text
            .map{($0?.characters.count)! > 4}
            .bindTo(nextButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{ notification in
            self.explanationLabelBottomConstraint.constant = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height + 16
            
        }).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{ notification in
            self.explanationLabelBottomConstraint.constant = 16
            
        }).addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productNameTF.becomeFirstResponder()
    }
}

