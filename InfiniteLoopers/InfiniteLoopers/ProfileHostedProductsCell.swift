//
//  ProductCell.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import Swarkn

class ProfileHostedProductsCell: UICollectionViewCell {

    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSpaces: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setBorderAndRadius(color: UIColor.lightGray, width: 0.5)
    }

}
