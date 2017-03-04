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

protocol PaginatedCollectionModel{
    var didRefresh:(() -> ())! { get set }
    var onLoadMore:(() -> ())! { get set }
    
    var dataSource:Variable<[Any]> { get }
    var nextPageAvailable:Bool { get set }
}
