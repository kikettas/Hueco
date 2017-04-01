//
//  ChatsVTableViewController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import IGListKit

final class ChatsV: UIViewController, IGListAdapterDataSource {
    var model:ChatsVMProtocol!
    var disposeBag = DisposeBag()
    
    var collectionView: IGListCollectionView = {
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var emptyView:EmptyCollectionBackgroundView!
    
    convenience init(model:ChatsVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("chats", comment: "Chats tab title"), image: UIImage(named: "ic_chat_tab_unselected"), selectedImage: UIImage(named: "ic_chat_tab_selected"))
        self.title = NSLocalizedString("chats", comment: "Chats view title")
    }
}


// MARK: - UIViewController

extension ChatsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppNavBarStyle()
        setupEmptyView()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        model.reloadData.filter{ $0 }.bindNext{_ in
            self.adapter.performUpdates(animated: true, completion: nil)
        }.addDisposableTo(disposeBag)
    }
    
    func setupEmptyView(){
        emptyView = EmptyCollectionBackgroundView(frame: collectionView.frame)

        Observable.combineLatest(model.dataSource.asObservable()
            .map{ return $0.isEmpty },AppManager.shared.userLogged.asObservable().map{$0 == nil}, resultSelector: { return ($0, $1)}).bindNext {(emptyChats, notLogged ) in
                if(notLogged){
                    let message = NSLocalizedString("empty_chats_message_not_logged", comment: "empty_chats_message_not_logged")
                    self.emptyView.setLabelMessage(emoji: "🔑", text: message)
                }else{
                    if !emptyChats{
                        self.emptyView.setLabelMessage(emoji: nil, text: nil)
                    }else{
                        self.emptyView.setLabelMessage(emoji: "💬", text: NSLocalizedString("empty_chats_message", comment: "empty_chats_message"))
                    }
                }
            }.addDisposableTo(disposeBag)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = view.bounds
    }
}

// MARK: - IGListAdapterDataSource

extension ChatsV{
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return [ChatSectionDataSource(chats:self.model.dataSource.value as! [Chat])] as [IGListDiffable]
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return ChatSectionController(didSelectChat: { index in
            Navigator.navigateToChat(from: self, chat: self.model.dataSource.value[index] as! Chat)
        })
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return emptyView
    }
}
