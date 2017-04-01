//
//  ProfilePageControllerV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ProfilePagingV: UIPageViewController, UIPageViewControllerDataSource  {
    
    var disposeBag = DisposeBag()
    var model:ProfilePagingVMProtocol!
    var pages:[UIViewController] = []
    var viewOrigin:CGPoint!
    
    convenience init(model:ProfilePagingVMProtocol, viewControllerOrigin:CGPoint) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.model = model
        self.viewOrigin = viewControllerOrigin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setupPages()

    }
    
    func setupPages(){
        let profileHostedProducts = ProfileHostedProductsV(model:ProfileHostedProductsVM(), viewControllerOrigin:viewOrigin)
        let profileParticipantProducts = ProfileParticipantProductsV(model:ProfileParticipantProductsVM(), viewControllerOrigin:viewOrigin)
        
        pages = [profileHostedProducts, profileParticipantProducts]
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
