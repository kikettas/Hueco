//
//  NewProductSecondStepVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol NewProductSecondStepVMProtocol {
    var client:ClientProtocol { get }
    var currencies:[String] { get }
    var productTypes:[String] { get }
    
    func publishProduct(name:String, category:ProductCategory,price:Float, slots:Int, description:String, currency:String, completion:@escaping ClientCompletion<Void>)
}

class NewProductSecondStepVM:NewProductSecondStepVMProtocol{
    var client: ClientProtocol
    var currencies: [String]
    var productTypes: [String]
    var disposeBag = DisposeBag()
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        currencies = ["€", "$"]
        productTypes = ["Licencia", "Cuenta", "Producto"]
    }
    
    func publishProduct(name:String, category:ProductCategory,price:Float, slots:Int, description:String, currency:String, completion:@escaping ClientCompletion<Void>){
        let product = Product(name: name, category: category, price: price, slots: slots, description: description, currency: currency, sellerID: AppManager.shared.userLogged.value!.uid)
        client.publishProduct(product: product.toJSON()).subscribe(onError:{ error in
            completion((), error as? ClientError)
        }, onCompleted:{
            completion((), nil)
        }).addDisposableTo(disposeBag)
    }
}
