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
    var ref:FIRDatabaseReference? { get }
    var _refHandle:FIRDatabaseHandle? { get }
    var newMessage:PublishSubject<Void> { get }
    var chatMessages:[ChatMessage] { get }
    var chat: Variable<Chat?> { get set }
    
    func initializeChat(chat:Chat)
    func sendMessage(withData data: ChatMessage)
}

class ChatVM:ChatVMProtocol{
    
    var disposeBag = DisposeBag()
    var ref: FIRDatabaseReference?
    var _refHandle: FIRDatabaseHandle?
    var newMessage: PublishSubject<Void> = PublishSubject()
    var chatMessages: [ChatMessage]
    var chat: Variable<Chat?>
    
    init(chat:Chat?){
        chatMessages = []
        self.chat = Variable(chat)
        
        self.chat.asObservable().filterNil().subscribe(onNext:{ [unowned self] chat in
            self.ref?.removeObserver(withHandle: self._refHandle!)
            self._refHandle = nil
            self.ref = nil
            self.chatMessages.removeAll()
            self.newMessage.onNext()
            self.initializeChat(chat: chat)
        }).addDisposableTo(disposeBag)
    }
    
    func initializeChat(chat:Chat) {
        ref = FIRDatabase.database().reference().child("chats").child(chat.chatID).child("messages")
        ref!.keepSynced(true)
        _refHandle = self.ref!.queryOrdered(byChild: "date").observe(.childAdded, with:{[weak self] (snapshot) in
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
        
        self.ref!.childByAutoId().setValue(message)
    }
    
    deinit {
        if let ref = ref{
            ref.removeObserver(withHandle: _refHandle!)
        }
    }
}
