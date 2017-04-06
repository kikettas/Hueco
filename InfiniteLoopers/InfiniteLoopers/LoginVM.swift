//
//  LoginVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/12/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol LoginVMProtocol:class{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    func logIn(withEmail:String,password:String, completion: @escaping ClientCompletion<Void>)
}

final class LoginVM: LoginVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client.shared) {
        self.client = client
    }
    
    func logIn(withEmail: String, password: String, completion: @escaping ClientCompletion<Void>) {
        client.logIn(withEmail: withEmail, password: password){ user, error in
            if let error = error{
                completion((), error)
                return
            }
            completion((), nil)
        }
    }
}
