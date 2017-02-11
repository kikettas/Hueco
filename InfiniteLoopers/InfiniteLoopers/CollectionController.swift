//
//  CollectionController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol CollectionController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var onLoadItemLimit:Int! { get }
    var didRefresh:(() -> ())! { get set }
    var onLoadMore:(() -> ())! { get set }
    
    var collectionView:UICollectionView! { get }
    var disposeBag:DisposeBag! { get }
    var refreshControl:UIRefreshControl! { get set }
}

extension CollectionController{
    
    func setupRefreshControl(){
        refreshControl.tintColor = UIColor.lightGray
        refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl?
            .rx
            .controlEvent(.valueChanged)
            .bindNext {
                self.didRefresh()
            }.addDisposableTo(disposeBag)
        collectionView.addSubview(refreshControl)
    }
    
    func willDisplay(atPosition: Int, collectionCount:Int){
        if((collectionCount - atPosition) == self.onLoadItemLimit){
            self.onLoadMore()
        }
    }
}
