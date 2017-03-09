//
//  Chat.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/5/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation

struct Chat{
    var chatID:String!
    var photo:String?
    var name:String!

    init(id:String, photo:String?, name:String) {
        chatID = id
        self.photo = photo
        self.name = name
    }
}
