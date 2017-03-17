//
//  EmptyCollectionBackgroundView.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/17/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class EmptyCollectionBackgroundView: UIView {

    var messageLabel:UILabel!
    var message:String = ""
    
    convenience init(message:String, frame:CGRect) {
        self.init(frame:frame)
        self.messageLabel.text = message
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews(){
        messageLabel = UILabel(frame: CGRect.zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont (name: "HelveticaNeue-Light", size: 25)
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
        addConstraints([
            NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        
        setNeedsLayout()
    }

}
