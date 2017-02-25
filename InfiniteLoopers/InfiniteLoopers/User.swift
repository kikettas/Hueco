//
//  User.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper

class User:Mappable{
    
    var username:String!
    var firstName:String?
    var lastName:String?
    var email:String!
    var avatar:String!
    var gender:Int?
    var phone:String?
    var createdAt:Date!
    var updatedAt:Date!
    var favoriteProducts:[Product]?
    var transactions:[Transaction]?
    
    required init?(map: Map) {

    }
}

// MARK: - Mappable

extension User{
    func mapping(map: Map) {
        username <- map["username"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        gender <- map["gender"]
        avatar <- map["avatar"]
        phone <- map["phone"]
        updatedAt <- map["updatedAt"] // transform
        createdAt <- map["createdAt"] // transform
        lastName <- map["username"]
        lastName <- map["username"]
        transactions <- map["transactions"]
        favoriteProducts <- map["favorites"]
    }
}
