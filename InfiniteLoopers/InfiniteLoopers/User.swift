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
    
    var uid:String!
    var nickname:String?
    var firstName:String?
    var lastName:String?
    var email:String?
    var avatar:String?
    var gender:Int?
    var phone:String?
    var createdAt:Date!
    var updatedAt:Date!
    var favoriteProducts:[Product]?
    var transactions:[Transaction]?
    
    required init?(map: Map) {

    }
    
    convenience init?(json:JSON, uid:String, photoUrl:String?, email:String?) {
        self.init(JSON:json)
        self.uid = uid
        self.avatar = photoUrl
        self.email = email
    }
}

// MARK: - Mappable

extension User{
    func mapping(map: Map) {
        nickname <- map["nickname"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        gender <- map["gender"]
        avatar <- map["avatar"]
        phone <- map["phone"]
        updatedAt <- map["updatedAt"] // transform
        createdAt <- map["createdAt"] // transform
        transactions <- map["transactions"]
        favoriteProducts <- map["favorites"]
    }
}
