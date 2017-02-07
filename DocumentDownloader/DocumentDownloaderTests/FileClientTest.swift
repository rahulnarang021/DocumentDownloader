//
//  FileClientTest.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/7/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import XCTest
@testable import DocumentDownloader

class FileClientTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - Test File Client
    func testFileClient() {
        let fileClient: FileClient = FileClient(url: testImageUrl)
        
        XCTAssert(fileClient.url.absoluteString == testImageUrl, "String to url conversion failed")
        
        let finalString: String = URL(string: testImageUrl)!.absoluteString.md5() + ".jpg"
        XCTAssert(fileClient.encodedFileName == finalString , "String to md5 conversion failed")
    }
}
