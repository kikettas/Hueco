//
//  MessageBar.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/20/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit
import Swarkn

extension MessageBar{
    
    public class func showWT(on:UIView? = nil, withMessage:String, duration: MessageBar.MessageBarDuration = .long, style: MessageBarStyle = .medium, backgroundColor: UIColor, position: MessageBarPosition = .bottom, didHide:@escaping ( ()->() ) = {}) -> MessageBar{
        if(style == .small){
            return MessageBar.show(on: on, withMessage: withMessage, duration: duration, style: style, backgroundColor: backgroundColor, position: position, font: UIFont(name: "HelveticaNeue-Bold", size: 12)!, didHide:didHide)
        }else{
            return MessageBar.show(on: on, withMessage: withMessage, duration: duration, style: style, backgroundColor: backgroundColor, position: position, font: UIFont(name: "HelveticaNeue-Bold", size: 17)!, didHide:didHide)
        }
    }
    
    public class func showError(on:UIView? = nil, message:String, position:MessageBarPosition = .top, didHide:@escaping ( ()->() ) = {}){
        _ = MessageBar.showWT(on: on, withMessage: message, duration: .long, style: .medium, backgroundColor: UIColor.mainErrorColor, position: position, didHide: didHide)
    }
}
