//
//  Counter.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation


class Counter {
    private (set) var value : Int32 = 0
    func increment () {
        OSAtomicIncrement32(&value)
    }
}
