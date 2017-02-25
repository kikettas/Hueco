//
//  NewProductSecondStepVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol NewProductSecondStepVMProtocol {
    var currencies:[String] { get }
    var productTypes:[String] { get }
}

class NewProductSecondStepVM:NewProductSecondStepVMProtocol{
    var currencies: [String]
    var productTypes: [String]
    
    init(){
        currencies = ["€", "$"]
        productTypes = ["Licencia", "Cuenta", "Producto"]
    }
}
