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
    public typealias JSON = Double
    
    public func transformFromJSON(_ value: Any?) -> Object?{
        return value != nil ? Date(timeIntervalSince1970: value as! TimeInterval) : nil
        
    }
    public func transformToJSON(_ value: Date?) -> JSON? {
        return value != nil ? value!.timeIntervalSince1970 : nil
        
    }
}
