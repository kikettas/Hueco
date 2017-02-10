//
//  Navigator.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit

class Navigator{
    
    public static func navigateToPublish(from:UIViewController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let publishTabV = PublishV(model: PublishVM())
        publishTabV.modalPresentationStyle = presentationStyle
        publishTabV.modalTransitionStyle = transitionStyle
        from.present(publishTabV, animated: true, completion: nil)
    }
    
    public static func navigateToLogin(from:UIViewController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let loginV = LoginV(model: LoginVM())
        loginV.modalPresentationStyle = presentationStyle
        loginV.modalTransitionStyle = transitionStyle
        from.present(loginV, animated: true, completion: nil)
    }
}
