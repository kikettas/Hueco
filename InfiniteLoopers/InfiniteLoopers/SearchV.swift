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
        
        collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{[unowned self] indexPath in
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x, y: cellCenter.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            Navigator.navigateToProductDetail(from: self, presentationStyle: .overFullScreen, product: self.model.dataSource.value[indexPath.row] as! Product, transitionDelegate: self)
        }).addDisposableTo(disposeBag)
        
        model.dataSource.asObservable().bindTo(collectionView.rx.items(cellIdentifier: "ProductCell", cellType: ProductCell.self)){row, element, cell in
            let product = element as! Product
            cell.productName.text = product.name
            cell.productOwner.text = product.seller.nickname
            cell.productOwnerRating.rating = Int(arc4random_uniform(UInt32(5) - UInt32(0)) + UInt32(0))
            cell.productOwnerRating.rating = product.seller.rating
            cell.productType.text = product.category.name
            cell.productPrice.text = product.priceWithCurrency
            cell.productSpaces.text = product.slotsFormatted
            
            let url = URL(string: product.seller.avatar ?? "")
            cell.productOwnerImage.kf.setImage(with: url, placeholder: UIImage(named:"ic_avatar_placeholder"),options: [.transition(ImageTransition.fade(1)), .processor(DefaultImageProcessor.default)])
            
            
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


