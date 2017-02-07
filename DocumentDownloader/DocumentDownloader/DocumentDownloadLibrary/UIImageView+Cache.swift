//
//  UIImageView+Cache.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/6/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // MARK: - Load Image From Url
    func setImageUrl(str: String, isShowActivity: Bool) {
        var activityView: UIActivityIndicatorView?
        if(isShowActivity) {
            activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView!.center = self.center
            activityView!.hidesWhenStopped = true
            activityView!.startAnimating()
            self.addSubview(activityView!)
        }
        self.image = nil
        DocumentDownload.downloadFile(url: str, target: self) { (filePath: String?, isSuccess:Bool, isCancelled: Bool) in
            DispatchQueue.main.async {
                if let activityIndicator = activityView {
                    activityIndicator.removeFromSuperview()
                }
                if let path = filePath, isSuccess {
                    self.image = UIImage(contentsOfFile: path)
                }
            }
        }
    }
    
    func setImageUrl(str: String) {
        self.setImageUrl(str: str, isShowActivity: false)
    }
}
