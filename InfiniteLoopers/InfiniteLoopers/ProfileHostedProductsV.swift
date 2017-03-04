//
//  ProfileHostedProductsV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ProfileHostedProductsV: UICollectionViewController {
    
    var model:ProfileHostedProductsVMProtocol!
    
    @IBOutlet weak var collectionLayout:UICollectionViewFlowLayout!
    
    convenience init(model:ProfileHostedProductsVMProtocol) {
        let layout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout:layout)
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delegate   = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
}
