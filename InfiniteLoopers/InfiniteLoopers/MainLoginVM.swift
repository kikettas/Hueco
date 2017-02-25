//
//  LoginVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import UIKit

protocol MainLoginVMProtocol{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    func loginWithFacebook(from:UIViewController, completion:@escaping ClientCompletion)
    func loginWithGoogle(from:UIViewController,completion: @escaping ClientCompletion)
}

class MainLoginVM:MainLoginVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client()) {
        self.client = client
    }
    
    func loginWithFacebook(from:UIViewController, completion:@escaping ClientCompletion) {
        client.logInWithFacebook(from: from, completion: completion)
    }
    
    func loginWithGoogle(from:UIViewController, completion: @escaping ClientCompletion) {
        client.logInWithGoogle(from:from ,completion: completion)
    }
}
