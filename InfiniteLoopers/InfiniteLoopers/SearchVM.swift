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
import Swarkn

protocol SearchVMProtocol:PaginatedCollectionModel{
    var loadingMore: Variable<Bool> { get }
    var refreshDataSource:PublishSubject<Void> { get }
}

class SearchVM:SearchVMProtocol{
    var dataSource: Variable<[Any]>
    var didRefresh: (() -> ())!
    var onLoadMore: (() -> ())!
    var loadingMore: Variable<Bool>
    var refreshDataSource: PublishSubject<Void>
    var nextPageAvailable: Bool = true
    var testing = 0
    
    init() {
        loadingMore = Variable(false)
        refreshDataSource = PublishSubject()
        dataSource = Variable([
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
            
        ])
        
        didRefresh = {
            print("didRefresh")
        }
        
        onLoadMore = {
            print("onLoadMore")
            self.loadingMore.value = true

            delay(2){
                if(self.nextPageAvailable){
                    self.testing = self.testing + 1
                    self.nextPageAvailable = !(self.testing == 5)
                    self.dataSource.value.append(contentsOf: [
                        ("Elliot","http://www.usanetwork.com/sites/usanetwork/files/2016/07/mrrobot_s2_cast_rami-malek2.jpg", "Router NSA"),
                        ("Jimmy McNulty","http://i.onionstatic.com/avclub/5105/62/16x9/1200.jpg", "Meizu MX3"),
                        ("Bernard","https://nypdecider.files.wordpress.com/2016/09/westworld-wright.jpg?quality=90&strip=all&w=600", "Placa arduino"),
                        ("Tyrion Lannister","https://pbs.twimg.com/profile_images/668279339838935040/8sUE9d4C.jpg", "Panda Antivirus")])
                    self.refreshDataSource.onNext()
                }
            }
        }
    }
}
