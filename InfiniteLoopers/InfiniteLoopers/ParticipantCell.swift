//
//  ParticipantCell.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/12/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class ParticipantCell: UICollectionViewCell {

    @IBOutlet weak var participantImage: UIImageView!
    @IBOutlet weak var participantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        participantImage.setBorderAndRadius(color: UIColor.mainDarkGrey, width: 0.5, cornerRadius: 5)
    } 
}
