//
//  ProfileHostedProductsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private let reuseIdentifier = "ParticipantCell"

class ProfileHostedProductsV: UIViewController {
    
    var disposeBag:DisposeBag = DisposeBag()
    var model:ProfileHostedProductsVMProtocol!
    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(model:ProfileHostedProductsVMProtocol) {
        self.init(nibName: nil, bundle: nil)

        self.model = model
    }
}


// MARK: - UIViewController

extension ProfileHostedProductsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        
        self.model.dataSource.asObservable().bindTo(self.collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: ProfileHostedProductsCell.self)){[unowned self] row, element, cell in
            cell.productName.text = self.model.dataSource.value[row].0
            cell.productPrice.text = self.model.dataSource.value[row].1
            cell.productType.text = "Cuenta"
            cell.productSpaces.text = self.model.dataSource.value[row].2
            }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.bindNext{_ in
            print(self.collectionView.numberOfItems(inSection: 0))
            }.addDisposableTo(disposeBag)
    }
}
