//
//  CustomAlertV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/12/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CustomAlertV: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    
    var disposeBag = DisposeBag()
    var alertTitle:String?
    var message:String!
    var positiveMessage:String!
    var negativeMessage:String?
    var completion:((Bool) -> ())?
    
    convenience init(title:String?,message:String, positiveMessage:String, negativeMessage:String?, completion:((Bool) -> ())?) {
        self.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.positiveMessage = positiveMessage
        self.negativeMessage = negativeMessage
        self.completion = completion
    }

}

// MARK: - UIViewController

extension CustomAlertV{
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setBorderAndRadius(color: UIColor.clear.cgColor, width: 0, cornerRadius: 5)
        negativeButton.isHidden = negativeMessage == nil
        alertTitleLabel.isHidden = alertTitle == nil
        
        if let alertTitle = alertTitle{
            alertTitleLabel.text = alertTitle
        }
        if let negativeMessage = negativeMessage{
            negativeButton.setTitle(negativeMessage, for: .normal)
        }
        
        positiveButton.setTitle(positiveMessage, for: .normal)
        messageLabel.text = message
        
        negativeButton.rx.tap.observeOn(MainScheduler.instance).bindNext { [unowned self] in
            self.dismiss(animated: true){
                if let completion = self.completion{
                    completion(false)
                }
            }
        }.addDisposableTo(disposeBag)
        
        positiveButton.rx.tap.observeOn(MainScheduler.instance).bindNext { [unowned self] in
            self.dismiss(animated: true){
                if let completion = self.completion{
                    completion(true)
                }
            }
            }.addDisposableTo(disposeBag)
    }
}

