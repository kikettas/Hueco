//
//  ForgotPasswordVM.swift
//  InfiniteLoopers
//
//  Created by Alma Martinez on 16/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol ForgotPasswordVMProtocol{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    
    func sendResetPasswordTo(email:String)
}

class ForgotPasswordVM:ForgotPasswordVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client.shared) {
        self.client = client
    }
    
    func sendResetPasswordTo(email: String) {
        client.sendResetPaswordTo(email: email){_,error in
            if let error = error{
                print(error)
                return
            }
            print("SHOW positive dialog, email sent")
        }
    }
}
