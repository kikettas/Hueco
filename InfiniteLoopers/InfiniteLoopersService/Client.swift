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


typealias ClientCompletion = (Any?,ClientError?) -> ()

protocol ClientProtocol {
    init(sessionManager:SessionManager)
    
    // API
    func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion)
    func logIn(withCredential: FIRAuthCredential, completion:@escaping ClientCompletion)
    func logInWithFacebook(from: UIViewController, completion:@escaping ClientCompletion)
    func logInWithGoogle(from: UIViewController, completion: @escaping ClientCompletion)
    func signUp(withEmail: String, password:String, completion:@escaping ClientCompletion)

}

class Client: ClientProtocol {
    
    let authHandler:AuthHandler
    var googleLoginDelegate:GoogleLoginDelegate!

    required public init(sessionManager: SessionManager = SessionManager()) {
        authHandler = AuthHandler()
    }
}
