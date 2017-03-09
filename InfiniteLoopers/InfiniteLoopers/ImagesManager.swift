//
//  ImagesManager.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/9/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import Kingfisher

class ImagesManager{
    public class func fetchImage(url:String, completion:@escaping (Image?,Error?) ->()){
        ImageCache.default.retrieveImage(forKey: "key_for_image", options: nil) {
            image, cacheType in
            if let image = image {
                completion(image,nil)
            } else {
                ImageDownloader.default.downloadImage(with: URL(string:url)!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    if let error = error{
                        completion(nil,error)
                        return
                    }
                    completion(image, nil)
                }
                
            }
        }
    }
}
