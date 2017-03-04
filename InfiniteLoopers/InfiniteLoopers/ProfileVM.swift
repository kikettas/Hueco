//
//  ProfileVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol ProfileVMProtocol {
    func logOut(completion: @escaping ClientCompletion<Void>)
}

class ProfileVM:ProfileVMProtocol{
    func logOut(completion:@escaping ClientCompletion<Void>){
        Client().signOut(completion: completion)
    }
}
