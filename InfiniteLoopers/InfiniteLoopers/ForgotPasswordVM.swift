//
//  ForgotPasswordVM.swift
//  InfiniteLoopers
//
//  Created by Alma Martinez on 16/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol ForgotPasswordVMProtocol:class{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    
    func sendResetPasswordTo(email:String, completion: @escaping ClientCompletion<Void>)
}

final class ForgotPasswordVM:ForgotPasswordVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client.shared) {
        self.client = client
    }
    
    func sendResetPasswordTo(email: String, completion: @escaping (Void, ClientError?) -> ()) {
        client.sendResetPaswordTo(email: email){_,error in
            if let error = error{
                completion((), error)
                return
            }
            completion((), nil)
        }
    }
}
