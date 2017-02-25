//
//  NewProductPagingVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

protocol NewProductPagingVMProtocol{
    var productName:String? { get set }
    
    func set(productName:String?)
}

class NewProductPagingVM:NewProductPagingVMProtocol{
    var productName: String?
    
    func set(productName: String?) {
        self.productName = productName
    }
}
