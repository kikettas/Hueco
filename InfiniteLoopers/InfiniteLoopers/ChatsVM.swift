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
        _ = chatIds.map{ chatID in
            if(!chats.value.contains(where:{ c in return chatID == c.chatID })){
                _ = FIRDatabase.database().reference().child("chats").child(chatID).observeSingleEvent(of: FIRDataEventType.value, with: {[unowned self] snapshot in
                    if let chat = snapshot.value as? [String:Any]{
                        if let members = chat["members"] as? JSON, members.keys.count == 2{
                            for member in members.keys{
                                if(member != AppManager.shared.userLogged.value?.uid){
                                    self.client.user(withId: member){ user, error in
                                        if let error = error{
                                            print(error)
                                            return
                                        }
                                        let c = Chat.init(id: chatID, photo: user.avatar, name: user.nickname ?? "No nickname")
                                        self.chats.value.append(c)
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }
        
        for i in 0..<chats.value.count{
            if(!chatIds.contains(chats.value[i].chatID)){
                self.chats.value.remove(at: 1)
            }
        }
    }
}
