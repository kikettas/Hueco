//
//  Client+API.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Alamofire
import Foundation
import FirebaseAuth
import FacebookLogin
import GoogleSignIn
import UIKit

extension Client{
    
    func check(nickName: String, completion: @escaping (Bool, ClientError?) -> ()) {
        sessionManager.request(Router.checkNickName(nickname: ["nickname":nickName])).responseValidatedJson{response in
            switch response{
                case .success(let json):
                    if let available = json["available"]{
                        completion(available as! Bool,nil)
                    }
                break
            case .failure(let error):
                completion(false,error as? ClientError)
                break
            }
        }
    }
    
    public func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion<User?>){
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password){(user,error) in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion(user as? User, nil)
            }
        }
    }
    
    func logIn(withCredential: FIRAuthCredential, completion: @escaping ClientCompletion<User?>) {
        FIRAuth.auth()?.signIn(with: withCredential){(user,error) in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion(user as? User, nil)
            }
        }
    }
    
    func logInWithFacebook(from: UIViewController, completion: @escaping ClientCompletion<User?>) {
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
    
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion<User?>) {
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
    
    func signOut(completion: @escaping ClientCompletion<Void>) {
        do{
            try FIRAuth.auth()?.signOut()
            completion((), nil)
        }catch{
            
        }
    }
    
    func sendResetPaswordTo(email: String, completion: @escaping ClientCompletion<Void>) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email){ error in
            if let error = error{
                completion((),ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion((),nil)
            }
        }
    }
    
    func signUp(withEmail: String, password: String, completion: @escaping ClientCompletion<User?>) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password) { (user, error) in
            if let error = error{
                completion(nil, ClientError.parseFirebaseError(errorCode: error._code))
            }else{
                completion(user as? User, nil)
            }
        }
    }
    
    func updateEmail(withEmail: String, completion: @escaping ClientCompletion<Void>) {
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(withEmail){ error in
            if let error = error{
                completion((),ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion((),nil)
            }
        }
    }
    
    func updatePassword(withPassword: String, completion: @escaping ClientCompletion<Void>) {
        let user = FIRAuth.auth()?.currentUser
        user?.updatePassword(withPassword){ error in
            if let error = error{
                completion((),ClientError.parseFirebaseError(errorCode: error._code))
                return
            }else{
                completion((),nil)
            }
        }
    }
}
