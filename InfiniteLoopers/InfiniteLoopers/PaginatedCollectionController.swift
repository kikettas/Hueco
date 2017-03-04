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
    var disposeBag:DisposeBag!
    var onLoadItemLimit:Int! = 6
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var collectionView: UICollectionView!

}

extension PaginatedCollectionController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        refreshControl = UIRefreshControl()
        disposeBag = DisposeBag()

        setupRefreshControl()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.register(UINib.init(nibName: "OnLoadMoreFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "OnLoadMoreFooter")
    }
    
    func setupRefreshControl(){
        refreshControl.tintColor = UIColor.lightGray
        refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl?
            .rx
            .controlEvent(.valueChanged)
            .observeOn(MainScheduler.instance)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if((model.dataSource.value.count - indexPath.row) == self.onLoadItemLimit){
            self.onLoadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(rgbValue: 0x000000,alpha:0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OnLoadMoreFooter", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return model.nextPageAvailable && model.dataSource.value.count > 0 ? CGSize(width: UIScreen.main.bounds.width, height: 150) : CGSize(width: 0.1, height: 0.1)
    }
}
