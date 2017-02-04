//
//  MainTabBarTests.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/4/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import XCTest
@testable import InfiniteLoopers


class MainTabBarVTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewControllersCount(){
        let mainTabBarView = MainTabBarV(model:MainTabBarVM())
        _ = mainTabBarView.view
        
        XCTAssertEqual(mainTabBarView.viewControllers?.count,5)
    }
}
