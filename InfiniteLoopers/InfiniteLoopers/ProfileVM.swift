//
//  ProfileVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileVMProtocol:class {
    
    var client:ClientProtocol { get }
    var image:Variable<String> { get }
    var nickname:Variable<String> { get }
    var rating:Variable<Int> { get }
    var ratingCount:Variable<String> { get }
    
    func logOut(completion: @escaping ClientCompletion<Void>)
}

final class ProfileVM:ProfileVMProtocol{
    
    var client: ClientProtocol
    var disposeBag = DisposeBag()
    var image: Variable<String>
    var nickname: Variable<String>
    var rating: Variable<Int>
    var ratingCount: Variable<String>
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        self.image = Variable("")
        self.nickname = Variable("")
        self.rating = Variable(0)
        self.ratingCount = Variable("")
        
        AppManager.shared.userLogged.asObservable().subscribe(onNext:{ [unowned self] user in
            if let user = user {
                self.image.value = user.avatar ?? ""
                self.nickname.value = user.nickname ?? ""
                self.rating.value = user.rating ?? 0
                let count = user.ratingIDs?.count ?? 0
                self.ratingCount.value = count != 0 ? "(\(count))" : ""
            }
        }).addDisposableTo(disposeBag)
    }
    
    func logOut(completion:@escaping ClientCompletion<Void>){
        client.signOut(completion: completion)
    }
}
