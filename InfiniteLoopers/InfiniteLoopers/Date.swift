//
//  Date.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/18/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation


extension Date{
    static func fromUTC(format:String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: format)
    }
    
    static func toUTC(from:Date) -> String?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: from)
    }
}
