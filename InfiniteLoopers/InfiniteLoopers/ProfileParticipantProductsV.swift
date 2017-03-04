//
//  ProfileParticipantProductsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private let reuseIdentifier = "ProductCell"

class ProfileParticipantProductsV: ProductPresenterController {
    
    var viewOrigin:CGPoint!
    
    convenience init(model:ProfileParticipantProductsVMProtocol, viewControllerOrigin:CGPoint) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.viewOrigin = viewControllerOrigin
        self.didRefresh = model.didRefresh
        self.onLoadMore = model.onLoadMore
    }
}


// MARK: - UIViewController

extension ProfileParticipantProductsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.model.dataSource.asObservable().bindTo(self.collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: ProductCell.self)){[unowned self] row, element, cell in
            let product = self.model.dataSource.value[row] as! (String,String,String,String,String)
            cell.productName.text = product.0
            cell.productPrice.text = product.1
            cell.productType.text = "Cuenta"
            cell.productOwner.text = product.3
            cell.productSpaces.text = product.2
            cell.productOwnerImage.kf.setImage(with: URL(string:product.4))
            cell.productOwnerRating.rating = 3
        }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.bindNext{[unowned self] _ in
            print(self.collectionView.numberOfItems(inSection: 0))
        }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{[unowned self] indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x + self.viewOrigin.x, y: cellCenter.y + self.viewOrigin.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: ("","Cuenta compartida", "Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends."), transitionDelegate: self)
        }).addDisposableTo(disposeBag)
    }
}
