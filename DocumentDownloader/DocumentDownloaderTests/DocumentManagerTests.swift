//
//  DocumentManagerTests.swift
//  DocumentManagerTests
//
//  Created by Rahul Narang on 2/7/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import XCTest
import Foundation
@testable import DocumentDownloader

class DocumentManagerTests: XCTestCase {
    var expectation: XCTestExpectation!

    var savedImagePath: String?
    override func setUp() {
        super.setUp()
        expectation = self.expectation(description: "Image Download")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.removeFileIfSaved()
    }
    
    // MARK: - Delete Saved File
    private func removeFileIfSaved() {
        if let filePath = savedImagePath {
            let fileManager: FileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: filePath)
            }
            catch {
                
            }
        }
    }
    // MARK: - TestCase For Succesfull download of image
    func testImageCaching() {
        let fileClient: FileClient = FileClient(url: testImageUrl)
        DownloadManager.sharedManager.downloadFile(fileClient: fileClient) {[unowned self] (path: String?, isSuccess, isCancel) in
            
            
            XCTAssert(isCancel == false, "Request is Cancelled automatically")
            XCTAssert(isSuccess == true, "Download Failed")
            if let filePath: String = path {
                XCTAssert(filePath.contains(fileClient.encodedFileName) , "Path not matched")

                let fileManager: FileManager = FileManager.default
                XCTAssert(fileManager.fileExists(atPath: filePath), "File Saved Unsuccesfull")
                self.savedImagePath = filePath
            }
            else {
                XCTAssert(false, "Download Failed")
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
        }
    }
    
    // MARK: - TestCase For Image Cancel
    func testImageCancel() {
        let imgView: UIImageView = UIImageView()// test target for cancel
        let fileClient: FileClient = FileClient(url: testImageUrl, target: imgView)
        DownloadManager.sharedManager.downloadFile(fileClient: fileClient) {[unowned self] (path: String?, isSuccess, isCancel) in
            
            XCTAssert(isCancel == true, "Request is Cancelled automatically")
            XCTAssert(isSuccess == false, "Download Failed")
            XCTAssertNil(path, "Download not cancelled")
            
            self.expectation.fulfill()
        }
        
        DownloadManager.sharedManager.cancelDownloadManually(fileClient: fileClient)
        waitForExpectations(timeout: 30) { (error) in
        }
        
    }
    
    
}
