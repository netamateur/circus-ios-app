//
//  CircusImgUnitTest.swift
//  Circus-ImgsUITests
//
//  Created by MACBOOK on 8/10/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import XCTest
@testable import Circus_Imgs

class CircusImgUnitTest: XCTestCase {
    
    override func setUp() {
        
        
        
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testConvertLongitude()
    {
        let photoLong = "19.3"
        let answer = Model.get.convertLongitude(photoLong)
        XCTAssertTrue(answer == 19.3, "String was not converted properly")
    }
    
    func testConvertLatitude()
    {
        let photoLat = "102.4"
        let answer = Model.get.convertLatitude(photoLat)
        XCTAssertTrue(answer == 102.4, "String was not converted properly")
    }
    
    func testSaveComment()
    {
        let author: String = "The Bard"
        let text: String = "t is not in the stars to hold our destiny but in ourselves."
        
        let newCard = Card(context: Model.get.managedContext)
        newCard.setValue("TestCard", forKey: "imageName")
        newCard.setValue("Dummy URL", forKey: "imageURL")
        newCard.setValue(false, forKey: "isLike")
        newCard.setValue("0", forKey: "imageLat")
        newCard.setValue("0", forKey: "imageLong")
        Model.get.imageDB.append(newCard)
        
        Model.get.saveComment(author_name: author, content: text, nCard: newCard)
        Model.get.fetchComments(card: newCard)
        let numOfComments = Model.get.commentsDB.count
        XCTAssert(numOfComments == 1)
    }
    
    func testGetUrlListFromDB()
    {
        let numOfCard = Model.get.imageDB.count
        let url = Model.get.getURLfromDB()
        XCTAssertEqual(numOfCard, url.count)
        
    }
    
}
