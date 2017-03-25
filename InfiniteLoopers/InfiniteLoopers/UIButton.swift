//
//  UIButton.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Kingfisher

extension UIButton{
    func setAvatarImage(urlString:String?, options:KingfisherOptionsInfo? = nil, controlState:UIControlState = .normal){
        let processor = ResizingImageProcessor(targetSize: CGSize(width: 70, height: 70), contentMode: ContentMode.aspectFill)
        var options = options
        if let _ = options{
            options!.append(.processor(processor))
        }else{
            options = [.processor(processor)]
        }

        self.kf.setImage(with: URL(string: urlString ?? ""), for: controlState, placeholder:UIImage(named:"ic_avatar_placeholder"), options:options)
    }
}
