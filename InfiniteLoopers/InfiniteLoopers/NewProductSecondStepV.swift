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

class NewProductSecondStepV: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var disposeBag:DisposeBag!
    var model:NewProductSecondStepVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    var currencyPicker:UIPickerView!
    var typePicker:UIPickerView!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var productTypeSelector: UITextField!
    @IBOutlet weak var currencyTF: UITextField!
    @IBOutlet weak var sharingCountTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationLabelBottomConstraint: NSLayoutConstraint!
    
    convenience init(model:NewProductSecondStepVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.disposeBag = DisposeBag()
        self.currencyPicker = UIPickerView()
        self.typePicker = UIPickerView()
    }
}

// MARK: - UIViewController

extension NewProductSecondStepV{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickers()
        
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
                let name = (self.parent as! NewProductPagingV).model.newProductName
                self.model.publishProduct(name: name, category: ProductCategory(name:self.productTypeSelector.text!),
                                          price: Float(self.quantityTF.text!)!, slots: Int(self.sharingCountTF.text!)!, description: self.descriptionTF.text!,
                                          currency: self.currencyTF.text!){ [weak self] _, error in
                                            guard let `self` = self else {
                                                return
                                            }
                                            if let error = error{
                                                print(error)
                                                return
                                            }
                                            Navigator.navigateToNewProductFinished(parent: self.parent as! NewProductPagingV)                                            
                }
            }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productTypeSelector.becomeFirstResponder()
    }
    
    func setPickers(){
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyTF.inputView = currencyPicker
        typePicker.delegate = self
        typePicker.dataSource = self
        productTypeSelector.inputView = typePicker
        currencyTF.inputAccessoryView = doneAccesoryView(textField: currencyTF)
        productTypeSelector.inputAccessoryView = doneAccesoryView(textField: productTypeSelector)
        productTypeSelector.reloadInputViews()
        currencyTF.reloadInputViews()
        
        currencyPicker
            .rx
            .itemSelected
            .observeOn(MainScheduler.instance)
            .map{self.model.currencies[$0.0]}
            .bindTo(currencyTF.rx.text).addDisposableTo(disposeBag)
        
        typePicker
            .rx
            .itemSelected
            .observeOn(MainScheduler.instance)
            .map{self.model.productTypes[$0.0]}
            .bindTo(productTypeSelector.rx.text).addDisposableTo(disposeBag)
    }
    
    func doneAccesoryView(textField:UITextField) -> UIView{
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.mainRed
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        doneButton.rx.tap.observeOn(MainScheduler.instance).bindNext {
            textField.resignFirstResponder()
            }.addDisposableTo(disposeBag)
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension NewProductSecondStepV{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.currencyPicker {
            return self.model.currencies.count
        }else{
            return self.model.productTypes.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.currencyPicker {
            return self.model.currencies[row]
        }else{
            return self.model.productTypes[row]
        }
    }
}

