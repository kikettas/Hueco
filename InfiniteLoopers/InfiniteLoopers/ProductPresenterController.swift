//
//  ProductPresenterController.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProductPresenterController: PaginatedCollectionController, UIViewControllerTransitioningDelegate, UIViewControllerPreviewingDelegate, UICollectionViewDataSource{
    let transition = PopAnimator()
    var originFrame = CGRect.zero
}

// MARK: - UIViewController
extension ProductPresenterController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
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
            return ProductDetailV(model:ProductDetailVM(product: model.dataSource.value[indexPath.row] as! Product))
        }
        return nil
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductPresenterController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.dataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = self.model.dataSource.value[indexPath.row] as! Product
        cell.productName.text = product.name
        cell.productType.text = product.category.name
        cell.productPrice.text = product.priceWithCurrency
        cell.productSpaces.text = product.slotsFormatted
        if cell.frame.height == 162{
            cell.productOwner.text = product.seller.nickname
            cell.productOwnerRating.rating = product.seller.rating
            cell.productOwnerImage.setAvatarImage(urlString: product.seller.avatar, options: [.transition(ImageTransition.fade(1)), .processor(DefaultImageProcessor.default)])
        }else{
            cell.productOwnerView.isHidden = true
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "onLoadMoreFooter", for: indexPath) as! OnLoadMoreFooter
        footer.onLoadMoreIndicator.startAnimating()
        return footer
    }
}
