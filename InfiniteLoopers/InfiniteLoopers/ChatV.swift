//
//  SharedV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatV: UIViewController, UITextFieldDelegate {
    
    var model:ChatVMProtocol!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var testTextField:UITextField!
    @IBOutlet weak var testButton:UIButton!
    @IBOutlet weak var testLabel: UILabel!

    
    convenience init(model:ChatVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.title = model.user


    }
}


// MARK: - UIViewController

extension ChatV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        testTextField.delegate = self
        self.testLabel.text = "hola"
        self.model.newMessage.subscribe(onNext:{(name,message) in
            print(self.testLabel.text)
            self.testLabel.text?.append("\n \(name): \(message)")
        }).addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
        testButton.rx.tap.observeOn(MainScheduler.instance).bindNext {
            self.model.sendMessage(withData: ["text":self.testTextField.text ?? "empty"])
        }.addDisposableTo(disposeBag)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
