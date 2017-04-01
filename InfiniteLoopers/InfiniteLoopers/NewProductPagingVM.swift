//
//  NewProductPagingVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol NewProductPagingVMProtocol:class{
    var newProductName:String { get set }
}

final class NewProductPagingVM:NewProductPagingVMProtocol{
    var newProductName: String
    
    init(){
        newProductName = ""
    }
}
