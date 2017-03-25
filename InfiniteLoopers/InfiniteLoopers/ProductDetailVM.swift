//
//  ProductDetailVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxCocoa
import RxSwift

protocol ProductDetailVMProtocol{
    var client:ClientProtocol { get set }
    var participants:Variable<[User?]> { get }
    var product:Variable<Product> { get }
    
    var productName:Variable<String?> { get }
    var productCategory:Variable<String?> { get }
    var productDescription:Variable<String?> { get }
    var productPrice:Variable<String?> { get }
    var productSellerNickname:Variable<String?> { get }
    var productSellerAvatar:Variable<String?> { get }
    var productSellerRating:Variable<Int?> { get }
    var productSpaces:Variable<String?> { get }
    
    func join(completion: @escaping ClientCompletion<Chat?>)
}

class ProductDetailVM:ProductDetailVMProtocol{
    
    var client: ClientProtocol
    var disposeBag = DisposeBag()
    var participants: Variable<[User?]>
    var product: Variable<Product>
    
    var productName: Variable<String?> = Variable(nil)
    var productCategory: Variable<String?> = Variable(nil)
    var productDescription: Variable<String?> = Variable(nil)
    var productPrice: Variable<String?> = Variable(nil)
    var productSellerNickname: Variable<String?> = Variable(nil)
    var productSellerAvatar: Variable<String?> = Variable(nil)
    var productSellerRating: Variable<Int?> = Variable(nil)
    var productSpaces: Variable<String?> = Variable(nil)
    
    var productRef:FIRDatabaseReference? = nil
    var productHandle:FIRDatabaseHandle? = nil
    
    init(product:Product, client:ClientProtocol = Client.shared){
        self.client = client
        self.product = Variable(product)
        self.participants = Variable([])
        
        self.productRef = FIRDatabase.database().reference().child("products").child(product.id)
        self.productHandle = productRef!.observe(.value, with: {[unowned self] (snapshot) in
            if let productJson = snapshot.value as? [String:Any] {
                self.product.value = Product(json: productJson, seller: self.product.value.seller)
                self.updateParticipants(productKeys: self.product.value.participantKeys)

            }
        })
        
        self.product.asObservable().bindNext {[unowned self] product in
            self.productName.value = product.name
            self.productCategory.value = product.category.name
            self.productDescription.value = product.productDescription == nil || (product.productDescription?.isEmpty)! ? NSLocalizedString("no_description_provided", comment: "No description provided"): product.productDescription
            self.productPrice.value = product.priceWithCurrency
            self.productSpaces.value = product.slotsFormatted
            self.productSellerNickname.value = product.seller.nickname
            self.productSellerRating.value = product.seller.rating
            self.productSellerAvatar.value = product.seller.avatar
            
            
            }.addDisposableTo(disposeBag)
    }
    
    private func updateParticipants(productKeys:[String]?){
        if let participants = productKeys{
            if participants.count != self.participants.value.count{
                self.participants.value.removeAll()
                participants.forEach{ uid in
                    if !self.participants.value.contains(where: {$0?.uid == uid}){
                        self.client.user(withId: uid){ [weak self] user, error in
                            guard let `self` = self else {
                                return
                            }
                            
                            self.participants.value.append(user)
                        }
                    }
                }
            }
            
        }else{
            participants.value.removeAll()
        }
        
    }
    
    func join(completion: @escaping ClientCompletion<Chat?>) {
//        client.join(ownID: (AppManager.shared.userLogged.value?.uid)!, sellerID: product.value.seller.uid, name: product.value.name, chatID: product.value.chat, productID: product.value.id).subscribe(onNext: { chat in
//            completion(chat, nil)
//        },onError: {error in
//            completion(nil, error as? ClientError)
//        }).addDisposableTo(disposeBag)
    }
    
    deinit {
        self.productRef?.removeObserver(withHandle: self.productHandle!)
        self.productRef = nil
        self.productHandle = nil
    }
}
