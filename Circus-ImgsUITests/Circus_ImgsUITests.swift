//
//  Circus_ImgsUITests.swift
//  Circus-ImgsUITests
//
//  Created by MACBOOK on 27/8/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import XCTest
import Pods_Circus_Imgs


class Circus_ImgsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        //continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        /*
        let app = XCUIApplication()
        XCTAssertEqual(app.tabBars.count, 1)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Search"].tap()
        tabBarsQuery.buttons["Messages"].tap()
        tabBarsQuery.buttons["Home"].tap()
        XCTAssertEqual(app.tables.count,1)
        XCTAssertEqual(app.buttons.count, 12)
        app.tables.cells.containing(.staticText, identifier:"mushroom").buttons["ic chat bubble outline"].tap()
        app.navigationBars["Comments"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
         */
        /*
         let app = XCUIApplication()
         let tabBarsQuery = app.tabBars
         tabBarsQuery.buttons["Favourite"].tap()
         tabBarsQuery.buttons["Search"].tap()
         
         let tablesQuery = app.tables
         tablesQuery.searchFields["Search"].tap()
         app.searchFields["Search"].typeText("gi")
         tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["digitalphoto"]/*[[".cells.staticTexts[\"digitalphoto\"]",".staticTexts[\"digitalphoto\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
         app.buttons["Cancel"].tap()
         app.navigationBars["Circus_Imgs.ResultsView"].buttons["Search"].tap()
         tabBarsQuery.buttons["Home"].tap()
         
         let circusNavigationBar = app.navigationBars["Circus"]
         circusNavigationBar.buttons["Back"].tap()
         circusNavigationBar.tap()
        
*/
    }
    
}
