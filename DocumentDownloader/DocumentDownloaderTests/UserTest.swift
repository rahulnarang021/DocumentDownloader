//
//  UserTest.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/7/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import XCTest
@testable import DocumentDownloader
class UserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test User Model Creation
    func testUserModelCreation() {
        let objUser: User = User(dictUser: testDictUser)
        XCTAssert(objUser.name == testDictUser["name"] as? String, "Incorrent User Model Creation")
        XCTAssert(objUser.userName == testDictUser["username"] as? String, "Incorrent User Model Creation")
        XCTAssert(objUser.userId == testDictUser["id"] as? String, "Incorrent User Model Creation")
        if let dictProfileImage = testDictUser["profile_image"] as? [String:String] {
            XCTAssert(objUser.getUserImageUrl() == dictProfileImage["large"], "Incorrent User Model Creation")
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
