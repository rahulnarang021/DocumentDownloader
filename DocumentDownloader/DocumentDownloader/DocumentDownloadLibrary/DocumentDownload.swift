//
//  DocumentDownload.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

class DocumentDownload: NSObject {
    
    // MARK: - Download File For URL
    class func downloadFile(url: String, target:AnyObject? = nil, completionHandler: @escaping DOCUMENTCOMPLETION) {
        
        let client = FileClient(url: url, target: target)
        if let filePath = CacheManager.fileExists(client: client) {
            completionHandler(filePath, true, false)
            DownloadManager.sharedManager.cancelDownload(fileClient: client)
            return
        }
        DownloadManager.sharedManager.downloadFile(fileClient: client, completion: completionHandler)
        
    }
    
    // MARK: - Cancel Request
    class func cancelDownloadForFile(url: String) {
        let client = FileClient(url: url)
        DownloadManager.sharedManager.cancelDownloadManually(fileClient: client)
    }
    
    
}
