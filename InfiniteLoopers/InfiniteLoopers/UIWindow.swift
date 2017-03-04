//
//  UIWindow.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }

    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController)
            
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            
        case let presentedViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentedViewController)
            
        default:
            return viewController
        }
    }
}
