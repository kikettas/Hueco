//
//  NotificationsVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol NotificationsVMProtocol{
    var dataSource:Variable<[Any]> { get }
    
    func reloadCollection(userID:String)
    func changeJoinRequestValue(joinRequest: JoinRequest, completion: @escaping ClientCompletion<JoinRequest.JoinRequestStatus?>)
}


class NotificationsVM:NotificationsVMProtocol{
    var client:Client
    var dataSource: Variable<[Any]>
    var disposeBag = DisposeBag()
    var initialized:Bool = false
    
    
    init(client:Client = Client.shared){
        self.client = client
        dataSource = Variable([])
        AppManager.shared.userLogged.asObservable().subscribe(onNext:{[unowned self] user in
            if let user = user{
                if(!self.initialized){
                    self.reloadCollection(userID: user.uid)
                }
            }else{
                for (index, element) in self.dataSource.value.enumerated(){
                    if element is JoinRequest{
                        self.dataSource.value.remove(at: index)
                    }
                }
            }
        }).addDisposableTo(disposeBag)
    }
    
    func reloadCollection(userID:String) {
        self.initialized = true
        client.joinRequests(userID: userID).subscribe(onNext:{[weak self] joinRequest in
            guard let `self` = self else {
                return
            }
            self.dataSource.value.append(joinRequest)
            },onError:{ _ in
                
        }, onCompleted:{
            print("onCompleted")
        }).addDisposableTo(self.disposeBag)

    }
    
    func changeJoinRequestValue(joinRequest: JoinRequest, completion: @escaping (JoinRequest.JoinRequestStatus?, ClientError?) -> ()) {
        client.changeJoinRequestStatus(joinRequest: joinRequest){status, error in
            if let error = error{
                completion(nil, error)
                return
            }
            completion(status, nil)
        }
    }
}
