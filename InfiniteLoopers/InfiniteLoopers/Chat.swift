//
//  Chat.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/5/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

class Chat:Mappable, IGListDiffable{
    var chatID:String!
    var photo:String?
    var name:String!
    var productID:String?
    var memberIDs:[String]!


    required init?(map: Map) {
        
    }
    
    convenience init?(id:String, json:JSON) {
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
}

// MARK: - Mappable

extension Chat{
    func mapping(map: Map) {
        photo <- map["photo"]
        name <- map["name"]
        productID <- map["productID"]
        if let members = map["members"].currentValue as? [String:Any]{
            memberIDs = members.keys.sorted()
        }
    }
}

// MARK: - IGListDiffable

extension Chat{
    func diffIdentifier() -> NSObjectProtocol {
        return chatID as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if let object = object as? Chat{
            return object.chatID == chatID
        }
        return false
    }
}

