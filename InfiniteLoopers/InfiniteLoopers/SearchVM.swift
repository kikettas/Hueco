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

protocol SearchVMProtocol{
    var dataSource:[Any] { get }
}

class SearchVM:SearchVMProtocol{
    var dataSource: [Any]
    
    init() {
        dataSource = []
    }
}
