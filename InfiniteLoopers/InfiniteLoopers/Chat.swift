//
//  Chat.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/5/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper

struct Chat:Mappable{
    var chatID:String!
    var photo:String?
    var name:String!
    var productID:String?
    var memberIDs:[String]!


    init?(map: Map) {
        
    }
    
    init?(id:String, json:JSON) {
        self.init(JSON:json)
        chatID = id
    }
    
    init(id: String, photo: String?, name: String, productID:String?, members:[String]) {
        self.chatID = id
        self.photo = photo
        self.name = name
        self.productID = productID
        self.memberIDs = members
    }
    
    mutating func mapping(map: Map) {
        photo <- map["photo"]
        name <- map["name"]
        productID <- map["productID"]
        if let members = map["members"].currentValue as? [String:Any]{
            memberIDs = members.keys.sorted()
        }
    }
}
