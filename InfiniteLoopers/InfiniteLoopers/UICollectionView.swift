//
//  UICollectionView.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/17/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import UIKit


extension UICollectionView{
    func applyChangeset(deleted:[Int], inserted:[Int], updated:[Int], animationStyle:UITableViewRowAnimation = .automatic) {
        
        self.performBatchUpdates({
            self.deleteItems(at: deleted.map { IndexPath(row: $0, section: 0) })
            self.insertItems(at: inserted.map { IndexPath(row: $0, section: 0) })
            self.reloadItems(at: updated.map { IndexPath(row: $0, section: 0) })
        }, completion:nil)
    }
}
