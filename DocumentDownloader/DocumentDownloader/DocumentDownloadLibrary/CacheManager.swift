//
//  CacheManager.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

class CacheManager: NSObject {

    // MARK: - Save File In Temp Directory
    class func cacheFileAtPath(fileName: String, filePath: String) ->String? {
        let fileManager: FileManager = FileManager.default
        if(fileManager.fileExists(atPath: filePath)) {
            let path = self.getFilePath(fileName: fileName)
            do {
                if(fileManager.fileExists(atPath: path)) {
                    try fileManager.removeItem(atPath: path)
                }
                
                
                try fileManager.moveItem(atPath: filePath, toPath: path)
                try fileManager.removeItem(atPath: filePath)
            }
            catch {
            }
            self.cleanCacheMemory()
            return path
        }
        return nil
    }
    
    // MARK: - Get Root File Paths
    private class func getFilePath(fileName: String) -> String {
        let dstPath: String = self.getCacheDirectoryPath()
        let path = dstPath + fileName
        return path
    }
    
    private class func getCacheDirectoryPath() -> String {
        return NSTemporaryDirectory()
    }
    
    // MARK: - Check if File Exists for Given File Name
    class func fileExists(client: FileClient) -> String? {
        let path = self.getFilePath(fileName: client.encodedFileName!)
        if(FileManager.default.fileExists(atPath: path)) {
            return path
        }
        return nil
    }
    
    // MARK: - Clean memory
    private class func cleanCacheMemory() { // clean memory if it exceeds threshold
        var memorySize: UInt64 = 0
        let fileManager: FileManager = FileManager.default
        let directorypath = self.getCacheDirectoryPath()
        var arrayFiles: [[String: Any]] = [[String: Any]]()
        do {
            let arrayContents: [String] = try fileManager.contentsOfDirectory(atPath: directorypath)
            arrayContents.forEach({ (path: String) in
                do {
                    let filePath: String = directorypath + path
                    let dictAttributes: [FileAttributeKey: Any] = try fileManager.attributesOfFileSystem(forPath: filePath)
                    if let size = dictAttributes[FileAttributeKey.size] as? UInt64 {
                        memorySize += size
                        let dictFile = ["filePath": filePath, FileAttributeKey.size.rawValue: dictAttributes[FileAttributeKey.size]!, FileAttributeKey.creationDate.rawValue: []] as [String : Any]
                        arrayFiles.append(dictFile)
                        
                    }
                }
                catch {
                    
                }
                // function to sort file with date
                func sorterForFileWithDate(first: [String: Any], second:[String: Any]) -> Bool {
                    let firstCreationDate: NSDate = first[FileAttributeKey.creationDate.rawValue] as! NSDate
                    let firstTimeInterval: TimeInterval = firstCreationDate.timeIntervalSince1970
                    let secondCreationDate: NSDate = second[FileAttributeKey.creationDate.rawValue] as! NSDate
                    let secondTimeInterval: TimeInterval = secondCreationDate.timeIntervalSince1970
                    return firstTimeInterval<secondTimeInterval
                }
                let thresholdSize = thresholdMemorySize * 1024 * 1024
                if(memorySize > thresholdSize) {
                    let sizeToReach = thresholdMemorySize/2
                    let sortedArray = arrayFiles.sorted(by: sorterForFileWithDate)
                    let fileCount = sortedArray.count-1
                    for index in 0...fileCount {
                        let dictFile: [String : Any] = sortedArray[index] as [String : Any]
                        do {
                            let filePath: String = dictFile["filePath"] as! String
                            try fileManager.removeItem(atPath: filePath)
                            memorySize -= dictFile[FileAttributeKey.size.rawValue] as! UInt64
                        }
                        catch {
                        }
                        if(memorySize <= sizeToReach) {
                            break
                        }
                    }
                }
            })
        }
        catch{
        }
    }
}
