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
        setupTableView()

        model.chats.asObservable().bindTo(tableView.rx.items(cellIdentifier: "ChatCell", cellType: ChatCell.self)){row,element,cell in
            
            cell.userName.text = element.name
            cell.userPhoto.setAvatarImage(urlString: element.photo)
            cell.userPhoto.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)

            cell.lastMessage.text = ""
        }.addDisposableTo(disposeBag)
    }
    
    func setupEmptyView(){
        emptyView = EmptyCollectionBackgroundView(frame: tableView.frame)

        Observable.combineLatest(model.chats.asObservable()
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
    
    func setupTableView(){
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        tableView.backgroundView = emptyView
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.mainBackgroundColor
        
        tableView.rx.itemSelected.observeOn(MainScheduler.instance).bindNext(){[weak self] indexpath in
            guard let `self` = self else {
                return
            }
            self.tableView.deselectRow(at: indexpath, animated: true)
            
            Navigator.navigateToChat(from: self, chat: self.model.chats.value[indexpath.row])
            
            }.addDisposableTo(disposeBag)
    }
}

