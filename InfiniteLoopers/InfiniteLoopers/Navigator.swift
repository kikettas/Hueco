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
    
    // MARK: - Login
    
    public static func navigateToMainLogin(from:UIViewController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let mainLoginV = MainLoginV(model: MainLoginVM())
        let nav = UINavigationController(rootViewController: mainLoginV)
        nav.modalPresentationStyle = presentationStyle
        nav.modalTransitionStyle = transitionStyle
        nav.modalPresentationCapturesStatusBarAppearance = true
        nav.setNavigationBarHidden(true, animated: false)
        nav.interactivePopGestureRecognizer?.delegate = mainLoginV as? UIGestureRecognizerDelegate
        
        from.present(nav, animated: true, completion: nil)
    }
    
    public static func navigateToLogin(from:UINavigationController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let loginV = LoginV(model: LoginVM())
        from.pushViewController(loginV, animated: true)
    }
    
    // MARK: - TabBar
    
    public static func navigateToPublish(from:UIViewController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let publishTabV = PublishV(model: PublishVM())
        publishTabV.modalPresentationStyle = presentationStyle
        publishTabV.modalTransitionStyle = transitionStyle
        from.present(publishTabV, animated: true, completion: nil)
    }
    
    public static func navigateToProductDetail(from:UIViewController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical, product:(String,String, String), transitionDelegate:UIViewControllerTransitioningDelegate? = nil){
        let productDetailV = ProductDetailV(model: ProductDetailVM(product: product))
        productDetailV.modalPresentationStyle = presentationStyle
        productDetailV.modalPresentationCapturesStatusBarAppearance = true
        if let delegate = transitionDelegate{
            productDetailV.transitioningDelegate = delegate

        }else{
            productDetailV.modalTransitionStyle = transitionStyle
        }

        from.present(productDetailV, animated: true, completion: nil)
    }
}
