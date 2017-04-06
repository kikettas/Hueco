//
//  NotificationsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import IGListKit

final class NotificationsV: UIViewController, IGListAdapterDataSource {

    var disposeBag = DisposeBag()
    var model:NotificationsVMProtocol!
    
    let collectionView: IGListCollectionView = {
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var emptyView:EmptyCollectionBackgroundView!
    
    convenience init(model:NotificationsVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("notifications", comment: "Notications tab title"), image: UIImage(named: "ic_notifications_tab_unselected"), selectedImage: UIImage(named: "ic_notifications_tab_selected"))
        self.title = NSLocalizedString("notifications", comment: "Notications view title")
    }
}

// MARK: - UIViewController

extension NotificationsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupAppNavBarStyle()
        emptyView = EmptyCollectionBackgroundView(frame: self.collectionView.frame)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        model.reloadData.filter{ $0 }.bindNext{ reload in
            self.adapter.performUpdates(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
        
        Observable.combineLatest(model.dataSource.asObservable()
            .map{ return $0.isEmpty },AppManager.shared.userLogged.asObservable().map{$0 == nil}, resultSelector: { return ($0, $1)}).bindNext {(emptyNotifications, notLogged ) in
                if(notLogged){
                    self.emptyView.setLabelMessage(emoji: "🔑", text: NSLocalizedString("empty_notifications_message_not_logged", comment: "empty_notifications_message_not_logged"))
                }else{
                    if !emptyNotifications{
                        self.emptyView.setLabelMessage(emoji: nil, text: nil)
                    }else{
                        self.emptyView.setLabelMessage(emoji: "📥", text: NSLocalizedString("empty_notifications_message", comment: "empty_notifications_message"))
                    }
                }
            }.addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - IGListAdapterDataSource

extension NotificationsV{
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return model.dataSource.value as! [IGListDiffable]
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return TransactionSectionController(model:model)
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return emptyView
    }
}
