//
//  ChatSplitterV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/20/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

final class ChatSplitterV: UISplitViewController, UISplitViewControllerDelegate {

    var chatsV:ChatsV!
    var chatV:ChatV!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("chats", comment: "Chats tab title"), image: UIImage(named: "ic_chat_tab_unselected"), selectedImage: UIImage(named: "ic_chat_tab_selected"))
        self.title = NSLocalizedString("chats", comment: "Chats view title")
    }
}

// MARK: - UISplitViewController

extension ChatSplitterV{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.edgesForExtendedLayout = []
        
        chatsV = ChatsV(model: ChatsVM())
        chatV = ChatV(model: ChatVM(chat: nil))
        
        preferredDisplayMode = .allVisible
        viewControllers = [UINavigationController(rootViewController: chatsV),UINavigationController(rootViewController: chatV)]
    }
    
    func changeChatOnDetailV(chat:Chat){
        chatV.model.chat.value = chat
    }
}

// MARK: - UISplitViewControllerDelegate

extension ChatSplitterV {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? ChatV else { return false }
        if topAsDetailController.model.chat.value == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}
