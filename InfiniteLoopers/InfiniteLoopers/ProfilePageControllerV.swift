//
//  ProfilePageControllerV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit

class ProfilePagingV: UIPageViewController, UIPageViewControllerDataSource  {
    
    var model:ProfilePagingVMProtocol!
    var pages:[UIViewController] = []
    
    convenience init(model:ProfilePagingVMProtocol) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        pages = [ProfileHostedProductsV(model:ProfileHostedProductsVM()), ProfileParticipantProductsV(model:ProfileParticipantProductsVM())]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension ProfilePagingV{
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
