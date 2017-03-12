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
    var dataSource: Variable<[Any]>
    var isNextPageAvailable: Bool = false
    var loadingMore: Variable<Bool>
    
    init(client:ClientProtocol = Client.shared){
        isRefreshing = BehaviorSubject(value: false)
        loadingMore = Variable(false)
        self.client = client
        dataSource = Variable([
            ("Netflix", "4€", "3/4","Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg"),
            ("Youtube TV", "4€", "2/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986"),
            ("HBO", "4€", "3/4","Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728"),
            ("Spotify", "4€", "3/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986"),
            ("Netflix", "4€", "3/4","Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg"),
            ("Youtube TV", "4€", "2/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986"),
            ("HBO", "4€", "3/4","Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728"),
            ("Spotify", "4€", "3/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986")
            ])
        
        didRefresh = {
            self.reloadCollection()
        }
        
        onLoadMore = {
            self.isNextPageAvailable = self.collectionKeys.count > (self.currentPage + 1) * client.itemsPerPage
            if(self.collectionKeys.count > self.currentPage * client.itemsPerPage && !self.loadingMore.value){
                self.fetchProducts()
            }
        }
    }
    
    func reloadCollection() {
        
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
