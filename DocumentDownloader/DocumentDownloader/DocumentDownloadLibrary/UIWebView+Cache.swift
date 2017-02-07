//
//  UIWebView+Cache.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/6/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

extension UIWebView {
    
    func loadFileAtPath(fileUrl: String) {
        DocumentDownload.downloadFile(url: "http://www.bkremea.com/wp-content/uploads/2016/11/dummy-file.pdf") { (filePath:String?, isSuccess:Bool, isCancel:Bool) in
            DispatchQueue.main.async {
                if let pdfPath = filePath {
                    let request = URLRequest(url: URL(string: pdfPath)!);
                    self.loadRequest(request);
                }
            }
        }
    }
}
