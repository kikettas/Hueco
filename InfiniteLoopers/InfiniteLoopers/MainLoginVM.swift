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
    func loginWithFacebook(from:UIViewController, completion:@escaping ClientCompletion)
}

class MainLoginVM:MainLoginVMProtocol{
    func loginWithFacebook(from:UIViewController, completion:@escaping ClientCompletion) {
        Client().logInWithFacebook(from: from, completion: completion)
    }
}
