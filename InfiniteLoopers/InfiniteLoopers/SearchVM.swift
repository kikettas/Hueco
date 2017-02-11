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
    var didRefresh:(() -> ())! { get set }
    var onLoadMore:(() -> ())! { get set }
    
    var dataSource:[(String,String,String)] { get }
}

class SearchVM:SearchVMProtocol{
    var dataSource: [(String,String,String)]
    var didRefresh: (() -> ())!
    var onLoadMore: (() -> ())!
    
    init() {
        dataSource = [
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO"),
        ("Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg", "Netflix"),
        ("Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986", "Spotify"),
        ("Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728", "HBO")

        ]
        didRefresh = {
            print("didRefresh")
        }
        onLoadMore = {
            print("onLoadMore")
        }
    }
}
