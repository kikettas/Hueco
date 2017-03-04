//
//  NetworkManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Alamofire
import Firebase


typealias ClientCompletion<T> = (T,ClientError?) -> ()

protocol ClientProtocol {
    init(sessionManager:SessionManager)
    
    // API
    func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion<User?>)
    func logIn(withCredential: FIRAuthCredential, completion:@escaping ClientCompletion<User?>)
    func logInWithFacebook(from: UIViewController, completion:@escaping ClientCompletion<User?>)
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion<User?>)
    func signOut(completion:@escaping ClientCompletion<Void>)
    func signUp(withEmail: String, password:String, completion:@escaping ClientCompletion<User?>)
    func updateEmail(withEmail: String,completion:@escaping ClientCompletion<Void>)
    func updatePassword(withPassword: String,completion:@escaping ClientCompletion<Void>)
    func sendResetPaswordTo(email:String, completion:@escaping ClientCompletion<Void>)

}

class Client: ClientProtocol {
    
    let authHandler:AuthHandler
    var googleLoginDelegate:GoogleLoginDelegate!

    required public init(sessionManager: SessionManager = SessionManager()) {
        authHandler = AuthHandler()
    }
}
