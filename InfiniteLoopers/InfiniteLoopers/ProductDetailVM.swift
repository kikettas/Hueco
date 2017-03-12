//
//  ProductDetailVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProductDetailVMProtocol{
    var client:ClientProtocol { get set }
    var participants:Variable<[User?]> { get }
    var product:Variable<Product> { get }
}

class ProductDetailVM:ProductDetailVMProtocol{
    
    var client: ClientProtocol
    var participants: Variable<[User?]>
    var product: Variable<Product>
    
    
    init(product:Product, client:ClientProtocol = Client.shared){
        self.client = client
        self.product = Variable(product)
        self.participants = Variable([])
        for _ in 0...(self.product.value.slots - 2){
            participants.value.append(nil)
        }
        if let participants = self.product.value.participantKeys{
            participants.forEach{
                self.client.user(withId: $0){ [weak self] user, error in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.participants.value.removeLast()
                    self.participants.value.insert(user, at: 0)
                    
                }
            }
        }
    }
}
