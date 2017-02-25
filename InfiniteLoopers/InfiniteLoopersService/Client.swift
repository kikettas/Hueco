//
//  NetworkManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Alamofire


typealias ClientCompletion = (Any?,ClientError?) -> ()

protocol ClientProtocol {
    init(sessionManager:SessionManager)
    
    // API
    func logIn(withEmail: String, password:String, completion:@escaping ClientCompletion)
    func signUp(withEmail: String, password:String, completion:@escaping ClientCompletion)

}

class Client: ClientProtocol {
    
    let authHandler:AuthHandler
    
    required public init(sessionManager: SessionManager = SessionManager()) {
        authHandler = AuthHandler()
    }
}
