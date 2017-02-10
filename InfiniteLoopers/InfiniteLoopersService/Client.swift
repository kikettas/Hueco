//
//  NetworkManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Alamofire


protocol ClientProtocol {
    init(sessionManager:SessionManager)
}

class Client: ClientProtocol {
    
    let authHandler:AuthHandler
    
    required init(sessionManager: SessionManager = SessionManager()) {
        authHandler = AuthHandler()
    }
}
