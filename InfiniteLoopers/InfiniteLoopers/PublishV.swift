//
//  PublishV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PublishV: UIViewController {
    
    var model:PublishVMProtocol!
    var disposeBag:DisposeBag = DisposeBag()
    @IBOutlet weak var closeButton: UIButton!
    
    convenience init(model:PublishVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
}


// MARK: - UIViewController

extension PublishV{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext {
                self.dismiss(animated: true, completion: nil)
            }.addDisposableTo(disposeBag)
        
    }
}

