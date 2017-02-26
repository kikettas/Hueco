//
//  ChatsVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation


protocol ChatsVMProtocol{
    var chats:[(String, String, String)] { get }
}

class ChatsVM:ChatsVMProtocol{
    var chats: [(String, String, String)] = []
    
    init(){
        chats.append(contentsOf: [
            ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg","Hola"),
            ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986","Hola1"),
            ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728","Hola2")
            ])
    }
}
