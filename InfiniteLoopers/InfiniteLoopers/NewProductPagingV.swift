//
//  NewProductPagingV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/25/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class NewProductPagingV: UIPageViewController {
    var model:NewProductPagingVMProtocol!
    var pages:[UIViewController]!
    
    convenience init(model:NewProductPagingVMProtocol){
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pages = [NewProductFirstStepV(model: NewProductFirstStepVM()),NewProductFirstStepV(model: NewProductFirstStepVM()),NewProductFirstStepV(model: NewProductFirstStepVM())]
    }
}

// MARK: - UIViewController

extension NewProductPagingV{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Navigator.navigateToNewProductFirstStep(parent: self, direction: .forward)
    }
}


// MARK: - UIPageViewControllerDataSource
/*
extension NewProductPagingV{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pages.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        return pages[previousIndex]
    }
}

*/
