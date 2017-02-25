//
//  NewProductSecondStep.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewProductSecondStepV: UIViewController {
    
    var disposeBag:DisposeBag!
    var model:NewProductSecondStepVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var productTypeSelector: UITextField!
    @IBOutlet weak var sharingCountTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationLabelBottomConstraint: NSLayoutConstraint!
    
    convenience init(model:NewProductSecondStepVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.disposeBag = DisposeBag()
    }
}

// MARK: - UIViewController

extension NewProductSecondStepV{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(onNext:{ notification in
            self.explanationLabelBottomConstraint.constant = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height + 16
            
        }).addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(onNext:{ notification in
            self.explanationLabelBottomConstraint.constant = 16
            
        }).addDisposableTo(disposeBag)
        
        backButton
            .rx
            .tap.observeOn(MainScheduler.instance)
            .bindNext {[unowned self] in
                Navigator.navigateToNewProductFirstStep(parent: self.parent as! NewProductPagingV, direction: .reverse)
            }.addDisposableTo(disposeBag)
        
        publishButton
            .rx
            .tap.observeOn(MainScheduler.instance)
            .bindNext {[unowned self] in
                Navigator.navigateToNewProductFinished(parent: self.parent as! NewProductPagingV)
            }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productTypeSelector.becomeFirstResponder()
    }
}
