//
//  ProductCell.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import Swarkn

class ProductCell: UICollectionViewCell {

    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSpaces: UILabel!
    @IBOutlet weak var productOwner: UILabel!
    @IBOutlet weak var productOwnerImage: UIImageView!
    @IBOutlet weak var productOwnerRating: RatingView!
    @IBOutlet weak var productOwnerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setBorderAndRadius(color: UIColor.lightGray, width: 0.5)
        self.productOwnerImage.setBorderAndRadius(color: UIColor.mainDarkGrey, width: 0.5)

    }

}
