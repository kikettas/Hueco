//
//  SearchVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Swarkn

protocol SearchVMProtocol:PaginatedCollectionModel{
    
}

class SearchVM:SearchVMProtocol{
    var dataSource: Variable<[Any]>
    var didRefresh: (() -> ())!
    var onLoadMore: (() -> ())!
    var loadingMore: Variable<Bool>
    var isRefreshing: BehaviorSubject<Bool>
    var disposeBag = DisposeBag()
    var client: ClientProtocol
    var collectionKeys: [String] = []
    var currentPage: Int = 0
    var isNextPageAvailable: Bool = false
    var reloadData: BehaviorSubject<(insert: [Int], delete: [Int], update: [Int])?>
    
    init(client:ClientProtocol = Client.shared) {
        self.client = client
        
        loadingMore = Variable(true)
        self.dataSource = Variable([])
        isRefreshing = BehaviorSubject(value: true)
        reloadData = BehaviorSubject(value: nil)
        reloadCollection()
        
        didRefresh = { [unowned self] in
            print("didRefresh")
            self.reloadCollection()
        }
        
        onLoadMore = { [unowned self] in
            self.isNextPageAvailable = self.collectionKeys.count > (self.currentPage + 1) * client.itemsPerPage
            if(self.collectionKeys.count > self.currentPage * client.itemsPerPage && !self.loadingMore.value){
                print("onLoadMore")
                self.fetchProducts()
            }
        }
    }
    
    func reloadCollection() {
        self.dataSource = Variable([])
        self.reloadData.onNext(nil)
        self.currentPage = 0
        client.productKeys{ [weak self] keys, error in
            guard let `self` = self else {
                return
            }
            
            if let error = error{
                print(error)
                return
            }
            print(keys)
            
            self.collectionKeys = keys
            self.fetchProducts()
        }
    }
    
    func fetchProducts(){
        var newProducts:[Any] = []
        self.loadingMore.value = true
        self.client.products(startingAt: self.collectionKeys[self.currentPage * self.client.itemsPerPage]).subscribe(onNext:{ product in
            newProducts.append(product)
        }, onCompleted:{[weak self] in
            guard let `self` = self else {
                return
            }
            self.currentPage += 1
            self.isRefreshing.onNext(false)
            self.loadingMore.value = false
            var insertions:[Int] = []
            
            for (index,_) in newProducts.enumerated(){
                insertions.append(self.dataSource.value.count + index)
            }
//            self.dataSource.value.append(contentsOf: newProducts)
//            self.reloadData.onNext((insertions, [], []))
            
        }).addDisposableTo(self.disposeBag)
    }
}
