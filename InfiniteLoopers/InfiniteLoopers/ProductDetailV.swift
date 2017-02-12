//
//  ProductDetailV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProductDetailV: UIViewController {

    var model:ProductDetailVMProtocol!
    var disposeBag = DisposeBag()
    

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    convenience init(model:ProductDetailVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }

}

// MARK: - UIViewController

extension ProductDetailV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderButtons()
        syncModelAndView()
        
    }
    
    func syncModelAndView(){
        productName.text = model.product.0
        productType.text = model.product.1
        productDescription.text = model.product.2
    }

    
    func setupHeaderButtons(){
        closeButton
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .bindNext(){
                self.dismiss(animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }
}
