//
//  JoinRequest.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

class JoinRequest:Mappable, IGListDiffable{
    
    var owner:User!
    var participant:User!
    var product:Product!
    var date:Date!
    var status:JoinRequestStatus!
    var id:String!
    
    enum JoinRequestStatus:String{
        case pending = "pending"
        case accepted = "accepted"
        case rejected = "rejected"
    }
    
    required init?(map: Map) {
        
    }
    
    convenience init?(json:JSON, owner:User, participant:User, product:Product){
        self.init(JSON:json)
        self.owner = owner
        self.participant = participant
        self.product = product
    }
}

// MARK: - Mappable

extension JoinRequest{
    
    func mapping(map: Map) {
        id <- map["id"]
        date <- (map["date"], DateTransform())
        status <- map["status"]
    }
}

// MARK: - IGListDiffable

extension JoinRequest{
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if let object = object as? JoinRequest {
            return id == object.id
        }
        return false
    }
}

