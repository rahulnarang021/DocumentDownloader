//
//  DownloadManager.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

//MARK: - Request Class
class Request { // Request Model For ImageDownloading Tasks
    var downloadTask: URLSessionDownloadTask!
    var target: AnyObject?
    var completionHandler: DOCUMENTCOMPLETION?
    var encodedFileName: String
    init(downloadTask: URLSessionDownloadTask, target: AnyObject?, completion: @escaping DOCUMENTCOMPLETION, encodedFileName: String) {
        self.downloadTask = downloadTask
        self.target = target
        self.encodedFileName = encodedFileName
        self.completionHandler = completion
    }
}

class DownloadManager: NSObject {

    static let sharedManager: DownloadManager = DownloadManager()
    private var session: URLSession = URLSession(configuration: URLSessionConfiguration.defaultConfigurationForFileDownloading())
  
    private let cacheQueue: DispatchQueue = DispatchQueue(label: "com.documentDownloader.FileCache") // seperate queue for caching files
    private let ioQueue: DispatchQueue = DispatchQueue(label: "com.documentDownloader.ioQueue") // seperate queue for updating dataTasks
    private var dataTasks: [Request] = [Request]()
    
    //MARK: - Start Downloading File
    func downloadFile(fileClient: FileClient, completion: @escaping DOCUMENTCOMPLETION) {
        self.cancelDownloadForFile(fileClient: fileClient, isManualCancel: false)
        
        let encodedFileName: String = fileClient.encodedFileName
        
        let dataTask: URLSessionDownloadTask = self.session.downloadTask(with: fileClient.url) {[unowned self] (url:URL?, urlResponse:URLResponse?, error: Error?) in
            
            guard url != nil && error == nil else {
                self.performCompletion(filePath: nil, isSuccess: false, encodedFileName: encodedFileName)
                return
            }
            if let filePath = url?.path {
                self.cacheQueue.async {
                    if let path = CacheManager.cacheFileAtPath(fileName: encodedFileName, filePath: filePath) {// saving file in cache
                        self.performCompletion(filePath: path, isSuccess: true, encodedFileName: encodedFileName)
                    }
                    else {
                        self.performCompletion(filePath: nil, isSuccess: false, encodedFileName: encodedFileName)
                    }
                }
            }
            else {
                self.performCompletion(filePath: nil, isSuccess: false, encodedFileName: encodedFileName)
            }
        }
        
        let request: Request = Request(downloadTask: dataTask, target: fileClient.target, completion: completion, encodedFileName: encodedFileName)

        self.updateRequestQueue(request: request)
    }
    
    // MARK: - Add and Update Operations in Queue
    private func updateRequestQueue(request: Request) {
        self.ioQueue.async {
            var isAdded: Bool = false
            var index = 0
            self.dataTasks.forEach { (objRequest: Request) in
                let downloadTask: URLSessionDownloadTask = objRequest.downloadTask
                if(downloadTask.state == .suspended && !isAdded) {
                    self.dataTasks.insert(request, at: index)
                    isAdded = true
                }
                
                index = index + 1
            }
            if(!isAdded) {
                self.dataTasks.append(request)
            }
            self.updateQueue()
        }
    }
    
    // MARK: - Update Queue
    private func updateQueue() {
        let runningRequests = dataTasks.filter{ $0.downloadTask.state == .running }
        if(runningRequests.count < maximumConcurrentDownloads) {
            let pendingRequests = dataTasks.filter { $0.downloadTask.state == .suspended }
            if(pendingRequests.count > 0) {
                let objRequest: Request = pendingRequests[0]
                objRequest.downloadTask.resume()
            }
        }
    }
    
    //MARK: - Perform Completion After success/failure
    private func performCompletion(filePath: String?, isSuccess: Bool, encodedFileName: String) {
        self.ioQueue.async {
            let taskCount = self.dataTasks.count
            for index in stride(from: taskCount-1, to: -1, by: -1) {
                let objRequest: Request = self.dataTasks[index]
                if (objRequest.encodedFileName == encodedFileName) {
                    if let completionHandler = objRequest.completionHandler {
                        completionHandler(filePath, isSuccess, false)
                    }
                    self.dataTasks.remove(at: index)
                }
            }
            self.updateQueue()

        }
    }
    
    //MARK: - Cancel Loading Manually
    func cancelDownloadManually(fileClient: FileClient) {
        self.cancelDownloadForFile(fileClient: fileClient, isManualCancel: true)
    }
    
    func cancelDownload(fileClient: FileClient) {
        self.cancelDownloadForFile(fileClient: fileClient, isManualCancel: false)
    }
    // MARK: - Cancel File downloading
    private func cancelDownloadForFile(fileClient: FileClient, isManualCancel: Bool) {// cancel file downloading for the same targets
        self.ioQueue.async {
            let taskCount = self.dataTasks.count
            for index in stride(from: taskCount-1, to: -1, by: -1) {
                let objRequest: Request = self.dataTasks[index]
                if let existingTarget = objRequest.target, let newTarget = fileClient.target {
                    if(existingTarget === newTarget && (!isManualCancel || fileClient.encodedFileName == objRequest.encodedFileName)) {
                        
                        if(isManualCancel){
                            if let completionHandler = objRequest.completionHandler {
                                completionHandler(nil, false, true)
                            }
                        }
                        if(objRequest.downloadTask.state == .running) {
                            
                            objRequest.downloadTask.cancel()
                        }
                        self.dataTasks.remove(at: index)
                    }
                }
            }
            self.updateQueue()
    }
    }
}

extension URLSessionConfiguration {
    // MARK: - Providing Default Session Configurations
    fileprivate class func defaultConfigurationForFileDownloading() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = loadingTimeout
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return configuration
    }
}
