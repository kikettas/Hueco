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
    var loadingMore: Variable<Bool> { get }
    
    func reloadCollection()
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
    
    init(client:ClientProtocol = Client.shared) {
        self.client = client
        
        loadingMore = Variable(false)
        dataSource = Variable([])
        isRefreshing = BehaviorSubject(value: true)
        reloadCollection()
        
        didRefresh = { [unowned self] in
            print("didRefresh")
            self.reloadCollection()
        }
        
        onLoadMore = { [unowned self] in
            print("onLoadMore")
            if(self.collectionKeys.count > self.dataSource.value.count && !self.loadingMore.value){
                delay(2){
                    self.fetchProducts()
                }
            }
        }
    }
    
    func reloadCollection() {
        self.dataSource.value = []
        self.currentPage = 0
        client.productKeys{ [weak self] keys, error in
            guard let `self` = self else {
                return
            }
            
            if let error = error{
                print(error)
                return
            }
            
            self.collectionKeys = keys
            self.fetchProducts()
        }
    }
    
    func fetchProducts(){
        self.loadingMore.value = true
        
        self.client.products(startingAt: self.collectionKeys[self.currentPage * self.client.itemsPerPage]).subscribe(onNext:{[weak self] product in
            guard let `self` = self else {
                return
            }
            self.dataSource.value.append(product)
            }, onCompleted:{
                print("Downloaded")
                self.currentPage += 1
                self.isRefreshing.onNext(false)
                self.loadingMore.value = false
                
                print(self.dataSource.value.count)
        }).addDisposableTo(self.disposeBag)
    }
}
