//
//  CreateAccountVM.swift
//  InfiniteLoopers
//
//  Created by Alma Martinez on 18/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Firebase
protocol CreateAccountVMProtocol{
    func signUp(withEmail: String, password: String)

}

class CreateAccountVM:CreateAccountVMProtocol{
    func signUp(withEmail: String, password: String) {
        Client().signUp(withEmail: withEmail, password: password){ user, error in
            if let error = error{
                print(error)
            }
            let user:FIRUser = user as! FIRUser
            print(user)
        }
    }
}
