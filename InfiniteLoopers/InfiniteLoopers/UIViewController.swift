//
//  UIViewController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func setupAppNavBarStyle(){
        self.navigationController?.navigationBar.barTintColor = UIColor.mainRed
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}
