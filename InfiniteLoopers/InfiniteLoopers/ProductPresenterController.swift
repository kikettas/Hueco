//
//  ProductPresenterController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit

class ProductPresenterController: PaginatedCollectionController, UIViewControllerTransitioningDelegate, UIViewControllerPreviewingDelegate{
    let transition = PopAnimator()
    var originFrame = CGRect.zero    
}

// MARK: - UIViewController
extension ProductPresenterController{
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForPreviewing(with: self, sourceView: collectionView)

    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension ProductPresenterController{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = originFrame
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension ProductPresenterController{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        previewingContext.sourceRect = CGRect(x: 16, y: 16, width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height - 32)
        if let indexPath = collectionView.indexPathForItem(at: location), let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
            previewingContext.sourceRect = cellAttributes.frame
            return ProductDetailV(model:ProductDetailVM(product: ("","Cuenta compartida", "Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends.")))
        }
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
}
