//
//  LoginVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/12/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol LoginVMProtocol{
    func logIn(withEmail:String,password:String)
}

class LoginVM: LoginVMProtocol{
    func logIn(withEmail: String, password: String) {
        Client().logIn(withEmail: withEmail, password: password){ user, error in
            if let error = error{
                print(error)
                return
            }
            print(user)
        }
    }
}
