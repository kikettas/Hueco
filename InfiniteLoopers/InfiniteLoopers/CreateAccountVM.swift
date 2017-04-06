//
//  CreateAccountVM.swift
//  InfiniteLoopers
//
//  Created by Alma Martinez on 18/2/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import RxCocoa
import RxSwift

protocol CreateAccountVMProtocol:class{
    var client:ClientProtocol { get }
    
    init(client:ClientProtocol)
    func signUp(withEmail: String, password: String, nickName:String) -> Observable<Void>
    func check(nickName:String) -> Observable<Bool>
    
}

final class CreateAccountVM:CreateAccountVMProtocol{
    var client: ClientProtocol
    
    required init(client: ClientProtocol = Client.shared) {
        self.client = client
    }
    
    func signUp(withEmail: String, password: String, nickName:String) -> Observable<Void>{
        return Observable.create({[unowned self] observer in
            self.client.signUp(withEmail: withEmail, password: password, nickName:nickName){ _, error in
                if let error = error{
                    observer.onError(error)
                    return
                }
                
                observer.onCompleted()
                return
            }
            return Disposables.create()
        })
    }
    
    func check(nickName: String) -> Observable<Bool> {        
        return Observable.create({[unowned self] observer in
            self.client.check(nickName: nickName, completion: { available, error in
                if let error = error{
                    observer.onNext(false)
                    observer.onError(error)
                    return
                }
                
                observer.onNext(available)
                return
                
            })
            return Disposables.create()
        })
    }
    
}
