//
//  SharedVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import RxCocoa
import RxSwift
import ObjectMapper

protocol ChatVMProtocol{
    var ref:FIRDatabaseReference! { get }
    var _refHandle:FIRDatabaseHandle! { get }
    var newMessage:PublishSubject<Void> { get }
    var chatMessages:[ChatMessage] { get }
    var chat:Chat { get }
    
    func initializeChat()
    func sendMessage(withData data: ChatMessage)
}

class ChatVM:ChatVMProtocol{
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var newMessage: PublishSubject<Void> = PublishSubject()
    var chatMessages: [ChatMessage]
    var chat: Chat
    
    init(chat:Chat){
        self.chat = chat
        chatMessages = []
        initializeChat()
    }
    
    func initializeChat() {
        ref = FIRDatabase.database().reference().child("chats").child(chat.chatID)
        ref.keepSynced(true)
        _refHandle = self.ref.child("messages").queryOrdered(byChild: "date").observe(.childAdded, with:{[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            let message = ChatMessage(JSON: snapshot.value as! [String:Any])
            if let message = message{
                self.chatMessages.append(message)
                self.newMessage.onNext()
            }
        })
    }
    
    func sendMessage(withData data: ChatMessage) {
        let message = Mapper().toJSON(data)
        
        self.ref.child("messages").childByAutoId().setValue(message)
    }
    
    deinit {
        ref.removeObserver(withHandle: _refHandle)
    }
}
