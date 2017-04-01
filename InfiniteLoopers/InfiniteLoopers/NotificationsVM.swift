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
    
    func changeTransactionValue(transaction: Transaction, completion: @escaping ClientCompletion<Transaction.TransactionStatus?>)
    func initializeCollection(userID:String)
    func initializeTransactionChangedReference(transactionID:String)
    func removeTransaction(transactionID:String)
    func resetObservers()
}


class NotificationsVM:NotificationsVMProtocol{
    var client:Client
    var dataSource: Variable<[Any]>
    var disposeBag = DisposeBag()
    var initialized:Bool = false
    var transactionsRef:FIRDatabaseReference?
    var transactionsAddedHandle:FIRDatabaseHandle?
    var transactionsRemovededHandle:FIRDatabaseHandle?
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
    
    func changeTransactionValue(transaction: Transaction, completion: @escaping (Transaction.TransactionStatus?, ClientError?) -> ()) {
        client.changeTransactionStatus(transaction: transaction){status, error in
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
        
        transactionsRef = FIRDatabase.database().reference().child("users").child(userID).child("transactions")
        transactionsAddedHandle = transactionsRef?.observe(.childAdded, with: { snapshot in
            self.initializeTransactionChangedReference(transactionID: snapshot.key)
        })
        
        transactionsRemovededHandle = transactionsRef?.observe(.childRemoved, with: { snapshot in
            self.removeTransaction(transactionID: snapshot.key)
        })
    }
    
    func initializeTransactionChangedReference(transactionID:String){
        if childReferences?[transactionID] == nil{
            childReferences?[transactionID] = FIRDatabase.database().reference().child("transactions").child(transactionID)
            childHandles?[transactionID] = childReferences?[transactionID]?.observe(.value, with: { snapshot in
                if let _ = snapshot.value as? JSON{
                    self.client.transaction(withID: snapshot.key, completion: {transaction, error in
                        if let error = error{
                            print(error)
                            return
                        }
                        self.dataSource.value.insert(transaction!, at: 0)
                        self.reloadData.onNext(true)
                    })
                }
            })
        }
    }
    
    func removeTransaction(transactionID:String){
        var removeIndex:Int?
        for (index, element) in dataSource.value.enumerated(){
            if let element = element as? Transaction, (element.id == transactionID){
                removeIndex = index
                break
            }
        }
        if let removeIndex = removeIndex{
            self.dataSource.value.remove(at: removeIndex)
            self.reloadData.onNext(true)
        }
    }
    
    func resetObservers(){
        self.initialized = false
        transactionsRef?.removeAllObservers()
        childReferences?.forEach{
            $0.value.removeObserver(withHandle: childHandles![$0.key]!)
        }
        transactionsRef = nil
        transactionsAddedHandle = nil
        transactionsRemovededHandle = nil
        self.dataSource.value.removeAll()
        self.reloadData.onNext(true)
        
    }
}
