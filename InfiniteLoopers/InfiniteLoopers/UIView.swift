//
//  UIView.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/26/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func loadingView(_ style: UIActivityIndicatorViewStyle = .white) -> UIView {
        let loadingView = UIView()
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.addSubview(activityIndicator)
        loadingView.addConstraints([
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        return loadingView
    }
    
    
    static func loadingBlurred(_ style: UIActivityIndicatorViewStyle = .white, blurredStyle : UIBlurEffectStyle = .light) -> UIView {
        let loadingBlurredView = UIView()
        loadingBlurredView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffect = UIBlurEffect(style: blurredStyle)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.frame = loadingBlurredView.bounds
        visualEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        loadingBlurredView.addSubview(visualEffect)
        loadingBlurredView.addSubview(activityIndicator)
        loadingBlurredView.addConstraints([
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingBlurredView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingBlurredView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        return loadingBlurredView
    }
    
    func addLoadingView(_ style: UIActivityIndicatorViewStyle = .white, isBlurred:Bool = false) -> UIView {
        let loadingView = isBlurred ? UIView.loadingBlurred(style) : UIView.loadingView(style)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadingView)
        self.addConstraints([
            NSLayoutConstraint(item: loadingView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            ])
        return loadingView
    }
}
