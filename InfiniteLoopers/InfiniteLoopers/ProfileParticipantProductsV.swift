//
//  ProfileParticipantProductsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private let reuseIdentifier = "ProductCell"

class ProfileParticipantProductsV: UIViewController {
    
    var disposeBag:DisposeBag = DisposeBag()
    var model:ProfileParticipantProductsVMProtocol!
    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(model:ProfileParticipantProductsVMProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }

    
}


// MARK: - UIViewController

extension ProfileParticipantProductsV{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.model.dataSource.asObservable().bindTo(self.collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: ProductCell.self)){[unowned self] row, element, cell in
            cell.productName.text = self.model.dataSource.value[row].0
            cell.productPrice.text = self.model.dataSource.value[row].1
            cell.productType.text = "Cuenta"
            cell.productOwner.text = self.model.dataSource.value[row].3
            cell.productSpaces.text = self.model.dataSource.value[row].2
            cell.productOwnerImage.kf.setImage(with: URL(string:self.model.dataSource.value[row].4))
            cell.productOwnerRating.rating = 3
        }.addDisposableTo(disposeBag)
        
        self.collectionView.rx.itemSelected.bindNext{_ in
            print(self.collectionView.numberOfItems(inSection: 0))
        }.addDisposableTo(disposeBag)
    }
}
