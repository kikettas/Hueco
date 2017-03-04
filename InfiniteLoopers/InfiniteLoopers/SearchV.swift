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

class SearchV: ProductPresenterController,UISearchControllerDelegate {

    var searchController: UISearchController!
    
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
    }
    
    override func setupCollectionView(){
        super.setupCollectionView()
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")

        
        (model as! SearchVMProtocol).refreshDataSource.subscribe(onNext:{
            self.collectionView.reloadData()
        }).addDisposableTo(disposeBag)
        
        collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{ indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x, y: cellCenter.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)

            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: ("","Cuenta compartida", "Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends."), transitionDelegate: self)
        }).addDisposableTo(disposeBag)
        
        model.dataSource.asObservable().bindTo(collectionView.rx.items(cellIdentifier: "ProductCell", cellType: ProductCell.self)){[unowned self] row, element, cell in
            let product = self.model.dataSource.value[row] as! (String, String, String)
            cell.productName.text = product.2
            cell.productOwner.text = product.0
            cell.productOwnerRating.rating = Int(arc4random_uniform(UInt32(5) - UInt32(0)) + UInt32(0))
            
            let url = URL(string: product.1)
            cell.productOwnerImage.kf.setImage(with: url,options: [.transition(ImageTransition.fade(1)), .processor(DefaultImageProcessor.default)], completionHandler: {
                (image, error, cacheType, imageUrl) in
            })
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


