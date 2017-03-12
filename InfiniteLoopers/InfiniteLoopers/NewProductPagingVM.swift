//
//  NewProductPagingVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol NewProductPagingVMProtocol{
    var newProductName:String { get set }
}

class NewProductPagingVM:NewProductPagingVMProtocol{
    var newProductName: String
    
    init(){
        newProductName = ""
    }
}
