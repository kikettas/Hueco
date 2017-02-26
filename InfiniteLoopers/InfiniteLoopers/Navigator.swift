//
//  Navigator.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/10/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit
import Swarkn

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
    
    public static func navigateToForgotPassword(from:UINavigationController, presentationStyle:UIModalPresentationStyle =
        UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let forgotPass = ForgotPasswordV(model: ForgotPasswordVM())
        from.pushViewController(forgotPass, animated: true)
    }
    
    public static func navigateToCreateAccount(from:UINavigationController, presentationStyle:UIModalPresentationStyle =
        UIModalPresentationStyle.overFullScreen, transitionStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let createAccount = CreateAccountV(model: CreateAccountVM())
        from.pushViewController(createAccount, animated: true)
    }
    
    public static func navigateBack(from:UINavigationController){
        from.popViewController(animated: true)        
    }
    
    public static func navigateToNewProduct(from:UIViewController, presentationStyle:UIModalPresentationStyle = UIModalPresentationStyle.overFullScreen, transitionStyle:UIModalTransitionStyle = UIModalTransitionStyle.coverVertical){
        let newProductV = NewProductPagingV(model: NewProductPagingVM())
        newProductV.modalPresentationStyle = presentationStyle
        newProductV.modalTransitionStyle = transitionStyle
        newProductV.modalPresentationCapturesStatusBarAppearance = true
        from.present(newProductV, animated: true, completion: nil)
    }
    
    // Mark: - New Product
    
    public static func navigateToNewProductFirstStep(parent:NewProductPagingV, direction:UIPageViewControllerNavigationDirection){
        parent.setViewControllers([parent.pages[0]], direction: direction, animated: true, completion: nil)
    }
    
    public static func navigateToNewProductSecondStep(parent:NewProductPagingV){
        parent.setViewControllers([parent.pages[1]], direction: .forward, animated: true, completion: nil)
    }
    
    public static func navigateToNewProductFinished(parent:NewProductPagingV){
        parent.setViewControllers([parent.pages[2]], direction: .forward, animated: true, completion: nil)
    }
    
    // Mark: - Chat
    
    
    public static func navigateToChat(from:UIViewController, userName:String){
        if(from is ChatV){
            from.navigationController?.pushViewController(ChatV(model: ChatVM(user:userName)), animated: true)
        }else if(from is SearchV || from is ProfileV || from is NotificationsV){
            if let tabBarV = UIApplication.shared.keyWindow?.rootViewController, tabBarV is MainTabBarV{
                (tabBarV as! UITabBarController).selectedIndex = 3
                if let navVC = (tabBarV as! UITabBarController).selectedViewController, navVC is UINavigationController, navVC.childViewControllers.first is ChatsV{
                    (navVC as! UINavigationController).pushViewController(ChatV(model: ChatVM(user:userName)), animated: true)
                }
            }
        }else{
            from.dismiss(animated: true){
                if let tabBarV = UIApplication.shared.keyWindow?.rootViewController, tabBarV is MainTabBarV{
                    (tabBarV as! UITabBarController).selectedIndex = 3
                    if let navVC = (tabBarV as! UITabBarController).selectedViewController, navVC is UINavigationController, navVC.childViewControllers.first is ChatsV{
                        (navVC as! UINavigationController).pushViewController(ChatV(model: ChatVM(user:userName)), animated: true)
                    }
                }
            }
        }
    }
        
    
    // MARK: - Common
    
    public static func navigateToShareProduct(from:UIViewController, sourceView:UIView, completion:@escaping () -> ()){
        
        let activityViewController = UIActivityViewController(activityItems: ["Producto compartido"], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed{
                completion()
            }
        }
        
        if(IS_IPHONE){
            from.present(activityViewController, animated: true, completion: nil)
        }else if(IS_IPAD){
            activityViewController.modalPresentationStyle = .popover
            activityViewController.popoverPresentationController?.sourceView = sourceView
            from.present(activityViewController, animated: true, completion: nil)
        }
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
