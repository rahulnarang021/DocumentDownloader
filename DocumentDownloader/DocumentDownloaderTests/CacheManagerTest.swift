//
//  CacheManagerTest.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/7/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import XCTest
import Foundation
@testable import DocumentDownloader
class CacheManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test Image Save in Temp
    func testImageSaveInCache() {
        if let path = CacheManager.cacheFileAtPath(fileName: testImageName, filePath: testImagePath) {
            let fileManager: FileManager = FileManager.default
            XCTAssert(fileManager.fileExists(atPath: path), "File Saved Unsuccesfull")
        }
        else {
            XCTAssert(false, "File Saved Unsuccesfull")
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
