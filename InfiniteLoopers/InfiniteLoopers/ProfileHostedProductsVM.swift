//
//  ProfileHostedProductsVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileHostedProductsVMProtocol:PaginatedCollectionModel{

}

class ProfileHostedProductsVM:ProfileHostedProductsVMProtocol{

    var didRefresh: (() -> ())!
    var onLoadMore: (() -> ())!
    
    var disposeBag = DisposeBag()
    var isRefreshing: BehaviorSubject<Bool>
    var client: ClientProtocol
    var collectionKeys: [String] = []
    var currentPage: Int = 0
    var dataSource: [Any]
    var isNextPageAvailable: Bool = false
    var loadingMore: Variable<Bool>
    var reloadData: BehaviorSubject<(insert: [Int], delete: [Int], update: [Int])?>
    
    init(client:ClientProtocol = Client.shared){
        self.client = client
        isRefreshing = BehaviorSubject(value: false)
        loadingMore = Variable(false)
        dataSource = []
        reloadData = BehaviorSubject(value: nil)

        didRefresh = {
        
        }
        
        onLoadMore = {

        }
        
        AppManager.shared.userLogged.asObservable().map { $0?.productIDs }.filter{$0 != nil}.bindNext {[unowned self] productIDs in
            productIDs!.forEach { productID in
                if !self.dataSource.contains(where: {($0 as! Product).id == productID}){
                    client.product(withID: productID){[weak self] product, error in
                        guard let `self` = self else {
                            return
                        }
                        if let error = error{
                            print(error)
                            return
                        }
                        self.dataSource.append(product!)
                        self.reloadData.onNext(([self.dataSource.count - 1],[],[]))
                    }
                }
            }
        }.addDisposableTo(disposeBag)
    }
    func reloadCollection() {
        
    }
}
