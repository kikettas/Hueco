//
//  Float.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
