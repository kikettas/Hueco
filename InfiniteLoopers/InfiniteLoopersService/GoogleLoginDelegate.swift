//
//  GoogleLoginDelegate.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleLoginDelegate:NSObject, GIDSignInDelegate, GIDSignInUIDelegate{
    
    var didLogin:(String?, String?, Error?) -> ()
    weak var viewController:UIViewController?
    
    init(from:UIViewController, didLogin:@escaping (String?, String?, Error?) -> ()){
        self.didLogin = didLogin
        self.viewController = from
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            didLogin(nil, nil, error)
            return
        }
        didLogin(user.authentication.idToken, user.authentication.accessToken, nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let error = error{
            print(error)
            return
        }
    }
}
