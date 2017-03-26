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
import IGListKit
import FirebaseDatabase

protocol NotificationsVMProtocol{
    var dataSource:Variable<[Any]> { get }
    var reloadData:BehaviorSubject<Bool> { get }
    
    func changeJoinRequestValue(joinRequest: JoinRequest, completion: @escaping ClientCompletion<JoinRequest.JoinRequestStatus?>)
    func resetObservers()
}


class NotificationsVM:NotificationsVMProtocol{
    var client:Client
    var dataSource: Variable<[Any]>
    var disposeBag = DisposeBag()
    var initialized:Bool = false
    var joinRequestsRef:FIRDatabaseReference?
    var joinRequestsHandle:FIRDatabaseHandle?
    var childReferences:[String:FIRDatabaseReference]?
    var childHandles:[String:FIRDatabaseHandle]?
    
    var reloadData: BehaviorSubject<Bool>
    
    
    init(client:Client = Client.shared){
        self.client = client
        reloadData = BehaviorSubject(value: false)
        dataSource = Variable([])
        AppManager.shared.userLogged.asObservable().subscribe(onNext:{[unowned self] user in
            if let user = user{
                if(!self.initialized){
                    self.initializeCollection(userID: user.uid)
                }
            }else{
                self.resetObservers()
                self.dataSource.value.removeAll()
            }
        }).addDisposableTo(disposeBag)
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
    
    func initializeCollection(userID:String){
        self.initialized = true
        childReferences = [:]
        childHandles = [:]
        
        joinRequestsRef = FIRDatabase.database().reference().child("users").child(userID).child("join_requests")
        joinRequestsHandle = joinRequestsRef?.observe(.childAdded, with: { snapshot in
            self.initializeJoinRequestChangedReference(requestID: snapshot.key)
        })
    }
    
    func initializeJoinRequestChangedReference(requestID:String){
        if childReferences?[requestID] == nil{
            childReferences?[requestID] = FIRDatabase.database().reference().child("join_requests").child(requestID)
            childHandles?[requestID] = childReferences?[requestID]?.observe(.value, with: { snapshot in
                if let _ = snapshot.value as? JSON{
                    self.client.joinRequest(withID: snapshot.key, completion: {joinRequest, error in
                        if let error = error{
                            print(error)
                            return
                        }
                        self.dataSource.value.insert(joinRequest!, at: 0)
                        self.reloadData.onNext(true)
                    })
                }
            })
        }
    }
    
    func resetObservers(){
        self.initialized = false
        joinRequestsRef?.removeObserver(withHandle: joinRequestsHandle!)
        childReferences?.forEach{
            $0.value.removeObserver(withHandle: childHandles![$0.key]!)
        }
        joinRequestsRef = nil
        joinRequestsHandle = nil
        self.dataSource.value.removeAll()
        self.reloadData.onNext(true)
        
    }
}
