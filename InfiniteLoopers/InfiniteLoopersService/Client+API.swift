//
//  Client+API.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import FirebaseAuth
import FacebookLogin
import UIKit

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
    
    func logIn(withCredential: FIRAuthCredential, completion: @escaping ClientCompletion) {
        FIRAuth.auth()?.signIn(with: withCredential){(user,error) in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion(user, nil)
            }
        }
    }
    
    func logInWithFacebook(from: UIViewController, completion: @escaping ClientCompletion) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: from){ loginResult in
            switch loginResult{
            case .failed(let error):
                print(error)
                completion(nil, ClientError.failedLoginWithFacebook)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.logIn(withCredential: credential, completion: completion)
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
