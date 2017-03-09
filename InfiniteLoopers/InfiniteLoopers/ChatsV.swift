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

class ChatsV: UIViewController {
    var model:ChatsVMProtocol!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        tableView.rx.itemSelected.observeOn(MainScheduler.instance).bindNext(){[weak self] indexpath in
            guard let `self` = self else {
                return
            }
            self.tableView.deselectRow(at: indexpath, animated: true)

            Navigator.navigateToChat(from: self, chat: self.model.chats.value[indexpath.row])
            
            }.addDisposableTo(disposeBag)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.mainBackgroundColor
        
        model.chats.asObservable().bindTo(tableView.rx.items(cellIdentifier: "ChatCell", cellType: ChatCell.self)){row,element,cell in
            
            cell.userName.text = element.name
            if let photo = element.photo{
                cell.userPhoto.kf.setImage(with: URL(string: photo))
            }
            
            cell.lastMessage.text = ""
        }.addDisposableTo(disposeBag)
    }
}

