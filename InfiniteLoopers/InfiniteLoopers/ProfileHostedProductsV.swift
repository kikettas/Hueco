//
//  ProfileHostedProductsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileHostedProductsV: ProductPresenterController {
    
    var viewOrigin:CGPoint!
    var emptyView:EmptyCollectionBackgroundView!

    convenience init(model:ProfileHostedProductsVMProtocol, viewControllerOrigin:CGPoint) {
        self.init(nibName: nil, bundle: nil)
        self.viewOrigin = viewControllerOrigin
        self.model = model
        self.didRefresh = model.didRefresh
        self.onLoadMore = model.onLoadMore
    }
}


// MARK: - UIViewController

extension ProfileHostedProductsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView = EmptyCollectionBackgroundView(frame: collectionView.frame)
        self.collectionView.backgroundView = emptyView

        self.collectionView!.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        self.model.reloadData.bindNext{[unowned self] changeSet in
            if let changeSet = changeSet{
                self.collectionView.applyChangeset(deleted: changeSet.delete, inserted: changeSet.insert, updated: changeSet.update)
            }else{
                self.collectionView.reloadData()
            }
        }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.bindNext{[unowned self] _ in
            print(self.collectionView.numberOfItems(inSection: 0))
            }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{[unowned self] indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x + self.viewOrigin.x, y: cellCenter.y + self.viewOrigin.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: self.model.dataSource.value[indexPath.row] as! Product, transitionDelegate: self)
        }).addDisposableTo(disposeBag)
        
        Observable.combineLatest(model.dataSource.asObservable()
            .map{ return $0.isNotEmpty },model.loadingMore.asObservable(), resultSelector: {
                return $0 || $1
        }).bindNext { hideMessage in
            if hideMessage{
                self.emptyView.setLabelMessage(emoji: nil, text: nil)
            }else{
                self.emptyView.setLabelMessage(emoji: "🚀", text: NSLocalizedString("empty_hosted_products", comment: "empty_hosted_products"))
            }
            
            }.addDisposableTo(disposeBag)
    }
}
