//
//  ChatsVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import RxCocoa
import RxSwift
import IGListKit

protocol ChatsVMProtocol{
    var client:ClientProtocol { get }
    var dataSource:Variable<[Any]> { get set}
    var reloadData:BehaviorSubject<Bool> { get }
}

class ChatsVM:ChatsVMProtocol{
    var disposeBag = DisposeBag()
    var dataSource: Variable<[Any]> = Variable([])
    var client: ClientProtocol
    var chatsReference:FIRDatabaseReference?
    var chatsAddedHandle:FIRDatabaseHandle?
    var chatsDeletedHandle:FIRDatabaseHandle?
    var childReferences:[String:FIRDatabaseReference]?
    var childHandles:[String:FIRDatabaseHandle]?
    
    var reloadData: BehaviorSubject<Bool>
    var initialized:Bool = false
    
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        reloadData = BehaviorSubject(value: false)
        
        AppManager.shared.userLogged.asObservable().subscribe(onNext:{[unowned self] user in
            if let user = user{
                if(!self.initialized){
                    self.initializeCollection(userID: user.uid)
                }
            }else{
                self.resetObservers()
            }
        }).addDisposableTo(disposeBag)
    }
    
    func initializeCollection(userID:String){
        self.initialized = true
        childReferences = [:]
        childHandles = [:]
        
        chatsReference = FIRDatabase.database().reference().child("users").child(userID).child("chats")
        chatsAddedHandle = chatsReference?.observe(.childAdded, with: {[unowned self] snapshot in
            self.initializeChildChatsReference(chatID: snapshot.key)
        })
        
        chatsDeletedHandle = chatsReference?.observe(.childRemoved, with: {[unowned self] snapshot in
            self.removeChat(chatID: snapshot.key)
        })
    }
    
    func initializeChildChatsReference(chatID:String){
        if childReferences?[chatID] == nil{
            childReferences?[chatID] = FIRDatabase.database().reference().child("chats").child(chatID)
            childHandles?[chatID] = childReferences?[chatID]!.observe(.value, with: {[unowned self] snapshot in
                if let chatJson = snapshot.value as? [String:Any]{
                    let c = Chat(id: chatID, json: chatJson)
                    guard let chat = c else { return }
                    self.updateChat(chat: chat)
                    self.reloadData.onNext(true)
                }
            })
        }
    }
    
    func resetObservers(){
        self.initialized = false
        chatsReference?.removeAllObservers()

        childReferences?.forEach{
            $0.value.removeObserver(withHandle: childHandles![$0.key]!)
        }
        chatsReference = nil
        chatsAddedHandle = nil
        chatsDeletedHandle = nil
        self.dataSource.value.removeAll()
        self.reloadData.onNext(true)
        
    }
    
    func updateChat(chat:Chat){
        let indexTpUpdate = self.dataSource.value.index(where: {
            if let chatToUpdate = $0 as? Chat{
                return chat.chatID == chatToUpdate.chatID
            }
            return false
        })
        
        if let index = indexTpUpdate{
            self.dataSource.value[index] = chat
        }else{
            self.dataSource.value.insert(chat, at: 0)
        }
    }
    
    func removeChat(chatID:String){
        var removeIndex:Int?
        for (index, element) in dataSource.value.enumerated(){
            if let element = element as? Chat, (element.chatID == chatID){
                removeIndex = index
                break
            }
        }
        if let removeIndex = removeIndex{
            self.dataSource.value.remove(at: removeIndex)
            self.reloadData.onNext(true)
        }
    }
}
