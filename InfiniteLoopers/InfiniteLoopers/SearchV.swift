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

class SearchV: UIViewController, UISearchControllerDelegate, CollectionController, UIViewControllerTransitioningDelegate {
    
    var didRefresh: (() -> ())!
    var onLoadMore: (() -> ())!
    
    var cellHeight: CGFloat = 162
    var cellWidth: CGFloat = 162
    var disposeBag: DisposeBag!
    var model:SearchVMProtocol!
    var onLoadItemLimit: Int!
    var refreshControl: UIRefreshControl!
    var searchController: UISearchController!
    let transition = PopAnimator()
    var originFrame = CGRect.zero
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(model:SearchVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.didRefresh = model.didRefresh
        self.onLoadMore = model.onLoadMore
        self.onLoadItemLimit = 0
        self.disposeBag = DisposeBag()
        self.refreshControl = UIRefreshControl()
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("search", comment: "Search tab title"), image: UIImage(named: "ic_search_tab_unselected"), selectedImage: UIImage(named: "ic_search_tab_selected"))
    }
    
}

// MARK: - UIViewController

extension SearchV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        setupCollectionView()
        setupRefreshControl()
        setupSearchController()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        collectionView.register(UINib.init(nibName: "OnLoadMoreCell", bundle: nil), forCellWithReuseIdentifier: "OnLoadMoreCell")
        
        model.refreshDataSource.subscribe(onNext:{
            self.collectionView.reloadData()
        }).addDisposableTo(disposeBag)
        
        collectionView.rx.itemSelected.observeOn(MainScheduler.instance).subscribe(onNext:{ indexPath in
            let loginV = PublishV(model:PublishVM())
            let cell = self.collectionView.cellForItem(at: indexPath)
            let cellCenter = self.collectionView.convert((cell?.frame.origin)!, to: self.collectionView.superview)
            self.originFrame = CGRect(x: cellCenter.x, y: cellCenter.y, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
            
            loginV.transitioningDelegate = self
            self.present(loginV, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
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

// MARK: - CollectionController

extension SearchV{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.nextPageAvailable ? model.dataSource.count + 1 : model.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row < model.dataSource.count){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            let product = model.dataSource[indexPath.row]
            cell.productName.text = product.2
            cell.productOwner.text = product.0
            cell.productOwnerRating.rating = Int(arc4random_uniform(UInt32(5) - UInt32(0)) + UInt32(0))
            
            let url = URL(string: product.1)
            cell.productOwnerImage.kf.setImage(with: url,options: [.transition(ImageTransition.fade(1)), .processor(DefaultImageProcessor.default)], completionHandler: {
                (image, error, cacheType, imageUrl) in
            })
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnLoadMoreCell", for: indexPath) as! OnLoadMoreCell
            cell.onLoadMoreIndicator.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row < model.dataSource.count){
            return CGSize(width: cellWidth, height: cellHeight)
        }else{
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(atPosition: indexPath.row, collectionCount: model.dataSource.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(rgbValue: 0x000000,alpha:0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SearchV{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = originFrame
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

