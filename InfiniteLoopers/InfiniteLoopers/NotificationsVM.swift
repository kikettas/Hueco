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

protocol NotificationsVMProtocol{
    var dataSource:Variable<[Any]> { get }
}

class NotificationsVM:NotificationsVMProtocol{
    var dataSource: Variable<[Any]>
    
    init(){
        dataSource = Variable([])
    }
}
