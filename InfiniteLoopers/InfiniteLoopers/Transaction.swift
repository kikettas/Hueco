//
//  Transaction.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper

class Transaction:Mappable{
    
    var createdAt:Date!
    var finished:Bool!
    var finishedAt:Date!
    var participantID:String!
    var productID:String!
    var ratingIDs:[String]!
    var sellerID:String!
    
    required init?(map: Map) {
        
    }
}

// MARK: - Mappable

extension Transaction{
    func mapping(map: Map) {
        createdAt <- (map["createdAt"], DateTransform())
        finishedAt <- (map["finishedAt"], DateTransform())
        finished <- map["finished"]
        participantID <- map["participant"]
        productID <- map["product"]
        sellerID <- map["seller"]
        if let ratings = map["ratings"].currentValue as? [String:Any]{
            ratingIDs = ratings.keys.map{$0}
        }
    }
}
