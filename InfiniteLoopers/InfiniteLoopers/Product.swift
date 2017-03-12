//
//  Product.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper

class Product:Mappable{
    var name:String!
    var category:ProductCategory!
    var chat:String?
    var currency:String!
    var published:Bool!
    var publishDate:Date!
    var state:Int?
    var seller:User!
    var sellerID:String!
    var price:Float!
    var slots:Int!
    var freeSlots:Int!
    var productDescription:String?
    var participantKeys:[String]?
    var id:String!
    
    var priceWithCurrency:String {
        return price.clean + currency
    }
    
    var slotsFormatted:String{
        return String(slots - freeSlots) + "/" + String(slots)
    }
    
    required init?(map: Map) {
        
    }
    
    convenience init(json:JSON, seller:User){
        self.init(JSON:json)!
        self.seller = seller
    }
    
    init(name:String, category:ProductCategory,price:Float, slots:Int, description:String, currency:String, sellerID:String) {
        self.name = name
        self.category = category
        self.price = price
        self.productDescription = description
        self.currency = currency
        self.sellerID = sellerID
        self.publishDate = Date()
        self.published = true
        self.slots = slots
        self.freeSlots = 0
    }
}

// MARK: - Mappable

extension Product{
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        category <- map["category"]
        chat <- map["chat"]
        published <- map["published"]
        publishDate <- (map["publish_date"], DateTransform())
        state <- map["state"]
        price <- map["price"]
        slots <- map["slots"]
        sellerID <- map["seller"]
        freeSlots <- map["free_slots"]
        productDescription <- map["description"]
        currency <- map["currency"]
        if let participants = map["participants"].currentValue as? [String:Any]{
            participantKeys = participants.keys.sorted()
        }
    }
}

