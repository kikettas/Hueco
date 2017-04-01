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
    var name:String?
    var email:String?
    var avatar:String?
    var gender:Gender?
    var phone:String?
    var createAt:Date!
    var updateAt:Date!
    var favoriteProducts:[Product]?
    var transactions:[Transaction]?
    var chatIDs:[String]?
    var ratingIDs:[String]?
    var productIDs:[String]?
    var transactionIDs:[String]?
    var rating:Int!
    
    enum Gender:String{
        case male = "male", female = "female"
        
        var commonDescription:String {
            switch self{
            case .male:
                return NSLocalizedString("male", comment: "male")
            case .female:
                return NSLocalizedString("female", comment: "female")
            }
        }
    }
    
    required init?(map: Map) {

    }
}

// MARK: - Mappable

extension User{
    func mapping(map: Map) {
        nickname <- map["nickname"]
        name <- map["name"]
        email <- map["email"]
        gender <- map["gender"]
        avatar <- map["avatar"]
        phone <- map["phone"]
        updateAt <- (map["updateAt"], DateTransform())
        createAt <- (map["createAt"],DateTransform())
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
        
        if let products = map["products"].currentValue as? [String:Any]{
            productIDs = products.keys.map{$0}
        }
    }
}
