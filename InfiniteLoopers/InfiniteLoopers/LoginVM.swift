//
//  LoginVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/12/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol LoginVMProtocol{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    func logIn(withEmail:String,password:String)
}

class LoginVM: LoginVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client.shared) {
        self.client = client
    }
    
    func logIn(withEmail: String, password: String) {
        client.logIn(withEmail: withEmail, password: password){ user, error in
            if let error = error{
                print(error)
                return
            }
            print(user)
        }
    }
}
