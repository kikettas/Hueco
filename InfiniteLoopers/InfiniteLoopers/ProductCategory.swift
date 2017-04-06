//
//  ProductCategory.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductCategory:Mappable{
    
    var name:String!
    
    required init?(map: Map) {
        
    }
    init(name:String){
        self.name = name
    }
}

// MARK: - Mappable

extension ProductCategory{
    func mapping(map: Map) {
        name <- map["name"]
    }
}

