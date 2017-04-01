//
//  Transaction.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper
import IGListKit

class Transaction:Mappable, IGListDiffable{
    
    var owner:User!
    var participant:User!
    var product:Product!
    var createdAt:Date!
    var status:TransactionStatus!
    var id:String!
    
    enum TransactionStatus:String{
        case pending = "pending"
        case accepted = "accepted"
        case rejected = "rejected"
    }
    
    required init?(map: Map) {
        
    }
    
    init(id:String){
        self.createdAt = Date()
        self.status = .pending
        self.id = id
    }
}

// MARK: - Mappable

extension Transaction{
    
    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- (map["createdAt"], DateTransform())
        status <- map["status"]
    }
}

// MARK: - IGListDiffable

extension Transaction{
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        if let object = object as? Transaction {
            return status == object.status
        }
        return false
    }
}

