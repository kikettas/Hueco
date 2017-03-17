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

class PaginatedCollectionController: UIViewController, UICollectionViewDelegateFlowLayout{
    
    var didRefresh:(() -> ())!
    var onLoadMore:(() -> ())!
    
    var model:PaginatedCollectionModel!
    
    var cellHeight:CGFloat!
    var cellWidth:CGFloat!
    var disposeBag:DisposeBag! = DisposeBag()
    var onLoadItemLimit:Int! = 1
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var collectionView: UICollectionView!

}

extension PaginatedCollectionController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()


        
        model.isRefreshing
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] isRefreshing in
                if(!isRefreshing && self.refreshControl.isRefreshing){
                    self.refreshControl.endRefreshing()
                }else if(isRefreshing && !self.refreshControl.isRefreshing){
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: -45), animated: true)
                    self.refreshControl.beginRefreshing()
                }
            }).addDisposableTo(disposeBag)
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "OnLoadMoreFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "onLoadMoreFooter")
    }
    
    func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl?
            .rx
            .controlEvent(.valueChanged)
            .observeOn(MainScheduler.instance)
            .bindNext { [unowned self] in
                self.didRefresh()
            }.addDisposableTo(disposeBag)
        collectionView.addSubview(refreshControl)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if((model.dataSource.count - indexPath.row) == self.onLoadItemLimit){
            self.onLoadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(rgbValue: 0x000000,alpha:0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {        
        return model.isNextPageAvailable && model.dataSource.count > 0 ? CGSize(width: UIScreen.main.bounds.width, height: 50) : CGSize(width: 0.1, height: 0.1)
    }
}
