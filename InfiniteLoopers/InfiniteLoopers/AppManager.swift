
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
    
    fileprivate var userReference:FIRDatabaseReference?
    fileprivate var userHandle:FIRDatabaseHandle?
    fileprivate var isInitializingApp:Bool = true
    var userLogged: Variable<User?>
    private init(){
        userLogged = Variable(nil)
        FIRAuth.auth()?.addStateDidChangeListener(){[unowned self](auth, user) in
            if let fUser = user{
                if self.userReference == nil{
                    self.userReference = FIRDatabase.database().reference().child("users").child(fUser.uid)
                    self.userReference!.keepSynced(true)
                    
                    self.userHandle = self.userReference!.observe(FIRDataEventType.value, with: { snapshot in
                        if let json = snapshot.value  as? [String: Any]{
                            let user = User(JSON: json)
                            self.userLogged.value = user
                        }
                    })
                }

            }else{
                self.userLogged.value = nil
                self.userReference?.removeObserver(withHandle: self.userHandle!)
                self.userReference = nil
                self.userHandle = nil
            }
        }
    }
    
    static func initialize(){
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = false
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        _ = AppManager.shared        
    }
}
