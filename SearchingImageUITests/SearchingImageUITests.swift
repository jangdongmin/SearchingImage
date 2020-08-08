//
//  SearchingImageUITests.swift
//  SearchingImageUITests
//
//  Created by Paul Jang on 2020/08/08.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import XCTest

class SearchingImageUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
//        let app = XCUIApplication()
//        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testSearch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("웹툰\n")
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 3.0))
        
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 10).children(matching: .other).element.swipeUp()
        
        let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 19).children(matching: .other).element
        element.swipeUp()

        let button = app.navigationBars["SearchingImage.ImageDetailView"].buttons["검색"]
        button.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 13).children(matching: .other).element/*@START_MENU_TOKEN@*/.swipeUp()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        collectionViewsQuery.children(matching: .cell).element(boundBy: 12).children(matching: .other).element.tap()
        
        app.scrollViews.element.swipeUp()
    }
    
    func testEmpty() throws {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("sfsafjkslajflekjflke\n")
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertFalse(resultCellOfFirst.waitForExistence(timeout: 3.0))
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
