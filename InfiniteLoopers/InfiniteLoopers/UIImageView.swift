//
//  Kingfisher.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/17/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView{
    func setAvatarImage(urlString:String?, options:KingfisherOptionsInfo? = nil){
        self.kf.setImage(with: URL(string: urlString ?? ""), placeholder:UIImage(named:"ic_avatar_placeholder"), options:options)
    }
}
