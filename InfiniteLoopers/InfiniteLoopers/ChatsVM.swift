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
    var chats:Variable<[Chat]> { get set}
}

class ChatsVM:ChatsVMProtocol{
    var disposeBag = DisposeBag()
    var chats: Variable<[Chat]> = Variable([])
    var client: ClientProtocol
    var chatsDBReference:FIRDatabaseReference?
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        
        
        AppManager.shared.userLogged.asObservable().subscribe(onNext:{[unowned self] user in
            if let user = user{
                if let chats = user.chatIDs{
                    self.updateChats(chatIds: chats)
                }
            }else{
                self.chats.value.removeAll()
            }
        }).addDisposableTo(disposeBag)
    }
    
    func updateChats(chatIds:[String]){
        removeDeletedChats(chatIds:chatIds)
        _ = chatIds.map{ chatID in
            if(!chats.value.contains(where:{ c in return chatID == c.chatID })){
                _ = FIRDatabase.database().reference().child("chats").child(chatID).observeSingleEvent(of: FIRDataEventType.value, with: {[unowned self] snapshot in
                    if let chatJson = snapshot.value as? [String:Any]{
                        let c = Chat(id: chatID, json: chatJson)
                        guard let chat = c else { return }
                        self.chats.value.append(chat)
                    }
                })
            }
        }
    }
    
    func removeDeletedChats(chatIds:[String]){
        var removeIndexes:[Int] = []
        for i in 0..<chats.value.count{
            if(!chatIds.contains(chats.value[i].chatID)){
                removeIndexes.append(i)
            }
        }
        
        removeIndexes.forEach{
            chats.value.remove(at: $0)
        }
    }
}
