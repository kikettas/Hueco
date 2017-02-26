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

protocol ChatVMProtocol{
    var ref:FIRDatabaseReference! { get }
    var _refHandle:FIRDatabaseHandle! { get }
    var messages: [FIRDataSnapshot]! { get set }
    var newMessage:PublishSubject<(String,String)> { get }
    var user:String { get }
    
    func configureDB()
    func sendMessage(withData data: [String: String])
}

class ChatVM:ChatVMProtocol{
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var messages: [FIRDataSnapshot]! = []
    var newMessage: PublishSubject<(String, String)> = PublishSubject()
    var user: String
    
    init(user:String){
        self.user = user
        configureDB()
    }
    
    deinit {
        
    }
    
    
    func configureDB() {
        ref = FIRDatabase.database().reference()
        _refHandle = self.ref.child("messages").observe(.childAdded, with:{[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            self.messages.append(snapshot)
            let name = (snapshot.value as! [String:String])["name"] ?? "noname"
            let text = (snapshot.value as! [String:String])["text"] ?? "emptymessage"

            self.newMessage.onNext((name,text))
            
        })
    }
    
    func sendMessage(withData data: [String : String]) {
        var mdata = data
        mdata["name"] = FIRAuth.auth()?.currentUser?.displayName
        if let photoURL = FIRAuth.auth()?.currentUser?.photoURL {
            mdata["photoURL"] = photoURL.absoluteString
        }
        
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
}
