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

protocol MainLoginVMProtocol:class{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    func loginWithFacebook(from:UIViewController, completion:@escaping ClientCompletion<Void>)
    func loginWithGoogle(from:UIViewController,completion: @escaping ClientCompletion<Void>)
}

final class MainLoginVM:MainLoginVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client.shared) {
        self.client = client
    }
    
    func loginWithFacebook(from:UIViewController, completion:@escaping ClientCompletion<Void>) {
        client.logInWithFacebook(from: from, completion: completion)
    }
    
    func loginWithGoogle(from:UIViewController, completion: @escaping ClientCompletion<Void>) {
        client.logInWithGoogle(from:from ,completion: completion)
    }
}
