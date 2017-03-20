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

class NotificationsV: UIViewController {

    var disposeBag = DisposeBag()
    var model:NotificationsVMProtocol!
    
    @IBOutlet weak var tableView:UITableView!
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
        setupAppNavBarStyle()
        emptyView = EmptyCollectionBackgroundView(frame: self.tableView.frame)
        tableView.backgroundView = emptyView
        
        model.dataSource.asObservable()
            .map{$0.isNotEmpty}
            .bindTo(emptyView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
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
}
