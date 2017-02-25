//
//  NewProductFinishedV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewProductFinishedV: UIViewController {
    
    var disposeBag:DisposeBag!
    var model:NewProductFinishedVMProtocol!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    convenience init(model:NewProductFinishedVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.disposeBag = DisposeBag()
    }
}

// MARK: - UIViewController

extension NewProductFinishedV{
    
    override func viewDidLoad() {
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext {[unowned self] in
                self.parent?.dismiss(animated: true, completion: nil)
            }.addDisposableTo(disposeBag)
        
        shareButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext {[unowned self] in
                Navigator.navigateToShareProduct(from: self, sourceView: self.shareButton){
                    self.parent?.dismiss(animated: true, completion: nil)
                }
            }.addDisposableTo(disposeBag)
    }

}
