//
//  JoinRequestCollectionCellCollectionViewCell.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class JoinRequestCollectionCell: UICollectionViewCell {

    @IBOutlet weak var participantPicture: UIButton!
    @IBOutlet weak var requestText: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var buttonStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
