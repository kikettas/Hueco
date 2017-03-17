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
            let product = self.model.dataSource.value[row] as! Product
            cell.productName.text = product.name
            cell.productPrice.text = product.priceWithCurrency
            cell.productType.text = product.category.name
            cell.productOwner.text = product.seller.nickname
            cell.productSpaces.text = product.slotsFormatted
            cell.productOwnerImage.setAvatarImage(urlString: product.seller.avatar)
            cell.productOwnerRating.rating = product.seller.rating
        }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{[unowned self] indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x + self.viewOrigin.x, y: cellCenter.y + self.viewOrigin.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: self.model.dataSource.value[indexPath.row] as! Product, transitionDelegate: self)
        }).addDisposableTo(disposeBag)
    }
}
