//
//  SFTabsTest.swift
//  Starfly
//
//  Created by Arturs Derkintis on 12/6/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import XCTest
@testable import Starfly

class SFTabsControllerTest: XCTestCase {
    var tabsController = SFTabsController()
    var tabContentController = SFTabsContentController()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tabsController.tabContentDelegate = tabContentController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTabController() {
        //Test simple add/remove/select functions
        tabsController.addTab()
        XCTAssertTrue(tabsController.tabs.count == 1, "Tabs count should be 1")
        
        tabsController.selectTab(0)
        
        if let tab = tabsController.tabById(0){
            XCTAssertTrue(tab.selected, "This tab must be selected")
            XCTAssertNotNil(tab.webViewController)
        }
        tabsController.addTab()
        tabsController.selectTab(1)
        if let tab = tabsController.tabById(1){
            XCTAssertTrue(tab.selected, "This tab must be selected")
        }
        
        tabsController.removeTabWithId(nil)
        tabsController.addTab()
        if let tab = tabsController.tabs.first{
            XCTAssertTrue(tab.id == 0, "This tab must be selected")
            tab.closeTab()
            XCTAssertTrue(tabsController.tabs.count == 1, "Tabs count should be one")
        }
        
    }
    
}
