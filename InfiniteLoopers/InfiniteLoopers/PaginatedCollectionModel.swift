//
//  CPaginatedCollectionModel.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol PaginatedCollectionModel:class{
    
    var didRefresh:(() -> ())! { get set }
    var onLoadMore:(() -> ())! { get set }
    
    var client:ClientProtocol { get }
    var dataSource:Variable<[Any]> { get }
    var isRefreshing:BehaviorSubject<Bool> { get }
    var loadingMore: Variable<Bool> { get }
    var collectionKeys:[String] { get set}
    var currentPage:Int { get set}
    var isNextPageAvailable:Bool { get set }
    var reloadData:BehaviorSubject<(insert:[Int], delete:[Int], update:[Int])?> { get }
    
    func reloadCollection()

}
