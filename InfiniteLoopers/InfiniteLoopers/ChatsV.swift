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

class ChatsV: UITableViewController {
    var model:ChatsVMProtocol!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var testTextField:UITextField!
    @IBOutlet weak var testButton:UIButton!
    @IBOutlet weak var testLabel: UILabel!
    
    
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
            Navigator.navigateToChat(from: self, userName: self.model.chats[indexpath.row].0)
        }.addDisposableTo(disposeBag)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.mainBackgroundColor
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatsV{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of numberOfSections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.model.chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.userName.text = model.chats[indexPath.row].0
        cell.userPhoto.kf.setImage(with: URL(string: model.chats[indexPath.row].1))
        cell.lastMessage.text = model.chats[indexPath.row].2
        return cell
    }
}

