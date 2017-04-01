//
//  SearchV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

final class SearchV: ProductPresenterController,UISearchControllerDelegate {
    
    var searchController: UISearchController!
    var emptyView:EmptyCollectionBackgroundView!
    
    convenience init(model:SearchVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.didRefresh = model.didRefresh
        self.onLoadMore = model.onLoadMore
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("search", comment: "Search tab title"), image: UIImage(named: "ic_search_tab_unselected"), selectedImage: UIImage(named: "ic_search_tab_selected"))
    }
}


// MARK: - UIViewController

extension SearchV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        setupSearchController()
        setupCollectionView()
    }
    
    override func setupCollectionView(){
        super.setupCollectionView()
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        emptyView = EmptyCollectionBackgroundView(frame: self.collectionView.frame)
        collectionView.backgroundView = emptyView
        
        Observable.combineLatest(model.dataSource.asObservable()
            .map{ return $0.isNotEmpty },model.loadingMore.asObservable(), resultSelector: {
                return $0 || $1
        }).bindNext { hideMessage in
            if hideMessage{
                self.emptyView.setLabelMessage(emoji: nil, text: nil)
            }else{
                self.emptyView.setLabelMessage(emoji: "🤷‍♂️", text: NSLocalizedString("empty_products_message", comment: "empty_products_message"))
            }
            
            }.addDisposableTo(disposeBag)
        
        model.dataSource.asObservable()
            .map{$0.isNotEmpty}
            .bindTo(emptyView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{[unowned self] indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x, y: cellCenter.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: self.model.dataSource.value[indexPath.row] as! Product, transitionDelegate: self)
        }).addDisposableTo(disposeBag)
        
        model.reloadData.bindNext { changeSet in
            if let changeSet = changeSet {
                self.collectionView.applyChangeset(deleted: changeSet.delete, inserted: changeSet.insert, updated: changeSet.update)
            }else{
                self.collectionView.reloadData()
            }
        }.addDisposableTo(disposeBag)

    }
    
    func setupSearchController(){
        let searchResultsView = SearchResultsV(style: .plain)
        self.searchController = UISearchController(searchResultsController: searchResultsView)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = searchResultsView
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.tintColor = UIColor.white
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
}


