//
//  ProfileHostedProductsVM.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileHostedProductsVMProtocol{
    var dataSource: Variable<[(String, String, String,String,String)]> { get }

}

class ProfileHostedProductsVM:ProfileHostedProductsVMProtocol{
    var dataSource: Variable<[(String, String, String,String,String)]>
    init(){
        dataSource = Variable([
            ("Netflix", "4€", "3/4","Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg"),
            ("Youtube TV", "4€", "2/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986"),
            ("HBO", "4€", "3/4","Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728"),
            ("Spotify", "4€", "3/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986"),
            ("Netflix", "4€", "3/4","Dwight Schrute","https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Rainn_Wilson.jpg/220px-Rainn_Wilson.jpg"),
            ("Youtube TV", "4€", "2/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986"),
            ("HBO", "4€", "3/4","Rick Sanchez","http://vignette3.wikia.nocookie.net/rickandmorty/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20160923150728"),
            ("Spotify", "4€", "3/4","Michael Scott","http://www.businessnewsdaily.com/images/i/000/008/678/original/michael-scott-the-office.PNG?1432126986")
            ])
    }
}
