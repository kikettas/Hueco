//
//  AppManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Firebase


class AppManager{
    static let shared:AppManager = AppManager()
    
    private init(){
        
    }
    
    var userLogged: FIRUser?{
        return FIRAuth.auth()?.currentUser
    }
}
