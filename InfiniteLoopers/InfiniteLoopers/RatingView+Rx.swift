//
//  RatingView+Rx.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Swarkn


extension Reactive where Base:RatingView{
    
    public var rating:Observable<Int> { return self.observe(Int.self,"rating").asObservable().map(){ $0! }}

}
