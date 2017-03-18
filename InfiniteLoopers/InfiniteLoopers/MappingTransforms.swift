//
//  MappingTransforms.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import ObjectMapper

public class DateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Object?{
        return value != nil && value! is String ? Date.fromUTC(format: value as! String) : nil
        
    }
    public func transformToJSON(_ value: Date?) -> JSON? {
        return value != nil ? Date.toUTC(from: value!) : nil
        
    }
}
