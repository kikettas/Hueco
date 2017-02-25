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
import GoogleSignIn
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
            case .failed(_):
                completion(nil, ClientError.failedLoginWithFacebook)
            case .cancelled:
                completion(nil, ClientError.logInCanceled)
            case .success(_, _, let accessToken):
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.logIn(withCredential: credential, completion: completion)
            }
        }
    }
    
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion) {
        googleLoginDelegate = GoogleLoginDelegate(from:from, didLogin: {idToken, accessToken, error in
            if let error = error{
                // figure out what kind of error is and parse to ClientError
                completion(nil,ClientError.parseGoogleSignInError(errorCode: error._code))
                return
            }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken!)
            self.logIn(withCredential: credential, completion: completion)
        })
        GIDSignIn.sharedInstance()?.delegate = googleLoginDelegate
        GIDSignIn.sharedInstance()?.uiDelegate = googleLoginDelegate
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sendResetPaswordTo(email: String, completion: @escaping ClientCompletion) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email){ error in
            if let error = error{
                completion(nil,ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion(nil,nil)
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
    
    func updateEmail(withEmail: String, completion: @escaping ClientCompletion) {
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(withEmail){ error in
            if let error = error{
                completion(nil,ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion(nil,nil)
            }
        }
    }
    
    func updatePassword(withPassword: String, completion: @escaping ClientCompletion) {
        let user = FIRAuth.auth()?.currentUser
        user?.updatePassword(withPassword){ error in
            if let error = error{
                completion(nil,ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion(nil,nil)
            }
        }
    }
}
