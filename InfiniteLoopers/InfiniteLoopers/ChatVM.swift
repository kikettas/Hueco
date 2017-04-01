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

protocol ChatVMProtocol:class{
    var newMessage:PublishSubject<Void> { get }
    var chatMessages:[ChatMessage] { get }
    var chat: Variable<Chat?> { get set }
    
    func initializeChat(chat:Chat)
    func sendMessage(withData data: ChatMessage)
}

final class ChatVM:ChatVMProtocol{
    
    var disposeBag = DisposeBag()
    var chatReference: FIRDatabaseReference?
    var chatMessagesReference: FIRDatabaseReference?
    var chatMessagesHandle: FIRDatabaseHandle?
    var newMessage: PublishSubject<Void> = PublishSubject()
    var chatMessages: [ChatMessage]
    var chat: Variable<Chat?>
    
    init(chat:Chat?){
        chatMessages = []
        self.chat = Variable(chat)
        
        self.chat.asObservable().filterNil().subscribe(onNext:{ [unowned self] chat in
            self.chatMessagesReference?.removeObserver(withHandle: self.chatMessagesHandle!)
            self.chatMessagesHandle = nil
            self.chatMessagesReference = nil
            self.chatReference = nil
            self.chatMessages.removeAll()
            self.newMessage.onNext()
            self.initializeChat(chat: chat)
        }).addDisposableTo(disposeBag)
    }
    
    func initializeChat(chat:Chat) {
        chatReference = FIRDatabase.database().reference().child("chats").child(chat.chatID)
        chatMessagesReference = chatReference!.child("messages")
        chatMessagesReference!.keepSynced(true)
        chatMessagesHandle = self.chatMessagesReference!.queryOrdered(byChild: "date").observe(.childAdded, with:{[weak self] (snapshot) in
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
        
        self.chatReference?.child("lastMessage").setValue(data.text())
        self.chatReference?.child("updatedAt").setValue(Date.toUTC(from: data.date()))

        self.chatMessagesReference!.childByAutoId().setValue(message)
    }
    
    deinit {
        if let ref = chatMessagesReference{
            ref.removeObserver(withHandle: chatMessagesHandle!)
        }
    }
}
