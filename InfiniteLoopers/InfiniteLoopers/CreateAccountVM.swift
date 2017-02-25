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
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    func signUp(withEmail: String, password: String)

}

class CreateAccountVM:CreateAccountVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client()) {
        self.client = client
    }
    func signUp(withEmail: String, password: String) {
        client.signUp(withEmail: withEmail, password: password){ user, error in
            if let error = error{
                print(error)
                return
            }
            let user:FIRUser = user as! FIRUser
            print(user)
        }
    }
}
