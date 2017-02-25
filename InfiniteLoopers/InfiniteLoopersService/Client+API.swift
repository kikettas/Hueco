//
//  Client+API.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import FirebaseAuth

extension Client{
    public func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion){
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password){(user,error) in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion(user, nil)
            }
        }
    }
    
    func signUp(withEmail: String, password: String, completion: @escaping ClientCompletion) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password) { (user, error) in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion(user, nil)
            }
        }
    }
}
