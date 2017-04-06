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

final class ProfileParticipantProductsV: ProductPresenterController {
    
    var viewOrigin:CGPoint!
    var emptyView:EmptyCollectionBackgroundView!

    
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
        emptyView = EmptyCollectionBackgroundView(frame: collectionView.frame)
        self.collectionView.backgroundView = emptyView
        self.collectionView!.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{[unowned self] indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x + self.viewOrigin.x, y: cellCenter.y + self.viewOrigin.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: self.model.dataSource.value[indexPath.row] as! Product, transitionDelegate: self)
        }).addDisposableTo(disposeBag)
        
        model.dataSource.asObservable()
            .map{ return $0.isNotEmpty }.bindNext { hideMessage in
            if hideMessage{
                self.emptyView.setLabelMessage(emoji: nil, text: nil)
            }else{
                self.emptyView.setLabelMessage(emoji: "🤝", text: NSLocalizedString("empty_participated_products", comment: "empty_participated_products"))
            }
            
            }.addDisposableTo(disposeBag)
        
        self.model.reloadData.bindNext{[unowned self] changeSet in
//            if let changeSet = changeSet, self.model.dataSource.value.count > 1{
//                self.collectionView.applyChangeset(deleted: changeSet.delete, inserted: changeSet.insert, updated: changeSet.update)
//            }else{
//                self.collectionView.reloadData()
//            }
            self.collectionView.reloadData()
            }.addDisposableTo(disposeBag)
    }
}
