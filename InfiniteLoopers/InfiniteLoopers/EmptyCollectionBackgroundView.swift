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
        messageLabel.text = ""
        addSubview(messageLabel)
        addConstraints([
            NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 32.0),
            NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -32.0),
            NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        
        setNeedsLayout()
    }
    
    func setLabelMessage(emoji:String?, text:String?){
        guard let text = text else{
            messageLabel.text = ""
            return
        }
        if let emoji = emoji{
            let attrString = NSMutableAttributedString(string: emoji+"\n", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 80)!])
            attrString.append(NSAttributedString(string:text))
            messageLabel.attributedText = attrString

        }else{
            messageLabel.text = text
        }

    }

}
