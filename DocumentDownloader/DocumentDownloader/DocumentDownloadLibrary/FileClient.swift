//
//  FileClient.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

class FileClient: NSObject {

    var url: URL!
    var fileExtension: String!
    var encodedFileName: String!
    weak var target: AnyObject?
    
    // MARK: - Set Client File
    init(url: String, target: AnyObject? = nil) {
        if let tempUrl = URL(string: url) {
            self.url = tempUrl;
        }
        self.target = target
        super.init()
        self.setFileExtension()
        self.setEncodedFileName()
    }
    
    // MARK: - Set File Extension For Different Data Types
    func setFileExtension() {
        if let fileURL = url {
            fileExtension = fileURL.pathExtension
        }
        else {
            fileExtension = "jpg"// by default image or override this method for different types
        }
    }
    
    // MARK: - Encode File Name From Url
    func setEncodedFileName() {
        if let encodedString: String = url?.absoluteString {
            
            let md5Str = encodedString.md5()

            encodedFileName = md5Str + "." + fileExtension
        }
    }
}
