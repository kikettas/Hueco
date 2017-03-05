//
//  AppManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import RxCocoa
import RxSwift
import GoogleSignIn

class AppManager{
    static let shared:AppManager = AppManager()
    
    fileprivate let dbReference:FIRDatabaseReference
    var userLogged: Variable<User?>
    private init(){
        dbReference = FIRDatabase.database().reference()
        userLogged = Variable(nil)
        FIRAuth.auth()?.addStateDidChangeListener(){(auth, user) in
            if let fUser = user{
                let userReference = self.dbReference.child("users").child(fUser.uid)
                userReference.keepSynced(true)
                _ = userReference.observe(FIRDataEventType.value, with: { snapshot in
                    if let json = snapshot.value{
                        let user = User(json: json as! JSON, uid: fUser.uid, photoUrl:fUser.photoURL?.absoluteString, email:fUser.email)
                        self.userLogged.value = user
                    }
                })
            }else{
                self.userLogged.value = nil
            }
        }
    }
    
    static func initialize(){
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        _ = AppManager.shared
    }
}
