//
//  ProfileParticipantProductsVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileParticipantProductsVMProtocol:PaginatedCollectionModel{
    var transactionIDs:[String] { get set }
}

final class ProfileParticipantProductsVM:ProfileParticipantProductsVMProtocol{
    
    var didRefresh: (() -> ())!
    var onLoadMore: (() -> ())!
    
    var isRefreshing: BehaviorSubject<Bool>
    var client: ClientProtocol
    var currentPage: Int = 0
    var collectionKeys: [String] = []
    var disposeBag = DisposeBag()
    var isNextPageAvailable: Bool = false
    var loadingMore: Variable<Bool>
    var reloadData: BehaviorSubject<(insert: [Int], delete: [Int], update: [Int])?>
    
    var transactionIDs: [String]
    var dataSource: Variable<[Any]>
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        isRefreshing = BehaviorSubject(value: false)
        loadingMore = Variable(true)
        transactionIDs = []
        dataSource = Variable([])
        reloadData = BehaviorSubject(value: nil)
        
        didRefresh = {
            
        }
        
        onLoadMore = {
            
        }
        
        AppManager.shared.userLogged.asObservable()
            .subscribe(onNext:{ [unowned self] user in
                if let user = user, let transactions = user.transactionIDs{
                    transactions.forEach {
                        if(!self.transactionIDs.contains($0)){
                            self.transactionIDs.append($0)
                            self.client.transaction(withID: $0){[weak self] transaction, error in
                                guard let `self` = self else {
                                    return
                                }
                                if let error = error{
                                    print(error)
                                    return
                                }
                                
                                if transaction!.participant.uid == AppManager.shared.userLogged.value?.uid{
                                    self.client.product(withID: transaction!.product.id){ product, error in
                                        if let error = error{
                                            print(error)
                                            return
                                        }
                                        self.loadingMore.value = false
                                        self.dataSource.value.append(product!)
                                        self.reloadData.onNext(([self.dataSource.value.count - 1],[],[]))
                                    }
                                }
                            }
                        }
                    }
                }else{
                    self.dataSource.value.removeAll()
                    self.reloadData.onNext(nil)
                    self.loadingMore.value = false
                }
            }).addDisposableTo(disposeBag)
        
    }
    
    func reloadCollection() {
        
    }
}
