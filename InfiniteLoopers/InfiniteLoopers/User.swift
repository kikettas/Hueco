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
    var chatIDs:[String]?
    var transactionIDs:[String]?
    var ratingIDs:[String]?
    var rating:Int!
    
    required init?(map: Map) {

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
        updatedAt <- (map["updatedAt"], DateTransform())
        createdAt <- (map["createdAt"],DateTransform())
        transactions <- map["transactions"]
        favoriteProducts <- map["favorites"]
        uid <- map["uid"]
        rating = map["rating"].currentValue as! Int? ?? 0
        
        if let chats = map["chats"].currentValue as? [String:Any]{
            chatIDs = chats.keys.map{$0}
        }
        
        if let transactions = map["transactions"].currentValue as? [String:Any]{
            transactionIDs = transactions.keys.map{$0}
        }
        
        if let ratings = map["ratings"].currentValue as? [String:Any]{
            ratingIDs = ratings.keys.map{$0}
        }
    }
}
