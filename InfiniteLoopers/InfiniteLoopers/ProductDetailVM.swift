//
//  ProductDetailVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation


protocol ProductDetailVMProtocol{
    var product:(String, String, String) { get }

}

class ProductDetailVM:ProductDetailVMProtocol{
    
    var product:(String, String, String)
    
    init(product:(String, String, String)){
        self.product = product
    }
}
