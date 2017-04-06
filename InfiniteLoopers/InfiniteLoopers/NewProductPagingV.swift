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
        self.model = model
        pages = [NewProductFirstStepV(model: NewProductFirstStepVM()),NewProductSecondStepV(model: NewProductSecondStepVM()),NewProductFinishedV(model: NewProductFinishedVM())]
    }
}

// MARK: - UIViewController

extension NewProductPagingV{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Navigator.navigateToNewProductFirstStep(parent: self, direction: .forward)
    }
}
