//
//  PopAnimator.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/11/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var presenting = true
    var originFrame = CGRect.zero
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let transitionKey = presenting ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
        let presentedView = transitionContext.view(forKey:transitionKey)
        
        let initialFrame = presenting ? originFrame : presentedView?.frame
        let finalFrame = presenting ? presentedView?.frame : originFrame
        
        let xScaleFactor = presenting ?
            (initialFrame?.width)! / (finalFrame?.width)! :
            (finalFrame?.width)! / (initialFrame?.width)!
        
        let yScaleFactor = presenting ?
            (initialFrame?.height)! / (finalFrame?.height)! :
            (finalFrame?.height)! / (initialFrame?.height)!
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = presenting ? 5.0/xScaleFactor : 0.0
        round.toValue = presenting ? 0.0 : 5.0/xScaleFactor
        round.duration = duration / 2
        presentedView?.layer.add(round, forKey: nil)
        presentedView?.layer.cornerRadius = presenting ? 0.0 : 5.0/xScaleFactor
        
        if(presenting){
            presentedView?.transform = scaleTransform
            presentedView?.center = CGPoint(
                x: initialFrame!.midX,
                y: initialFrame!.midY)
            presentedView?.clipsToBounds = true
        }
        if(presenting){
            containerView.addSubview((transitionContext.view(forKey: .to))!)
        }
        containerView.bringSubview(toFront: presentedView!)
        
        UIView.animate(withDuration: duration, delay:0.0,
                       options: [],
                       animations: {
                        presentedView?.transform = self.presenting ?
                            CGAffineTransform.identity : scaleTransform
                        
                        presentedView?.alpha = self.presenting ? 1 : 0.5
                        
                        presentedView?.center = CGPoint(x: (finalFrame?.midX)!,
                                                        y: (finalFrame?.midY)!)
                        
        }, completion:{_ in
            transitionContext.completeTransition(true)
        })
    }
}
