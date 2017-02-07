//
//  StringMd5Test.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/7/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import XCTest
@testable import DocumentDownloader
class StringMd5Test: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test Md5 Creation of String
    func testStringToMd5() {
        let string: String = "Hello"
        XCTAssert(string.md5() == "8b1a9953c4611296a827abf8c47804d7", "MD5 Conversion Incorrect")
    }
    
    
}
