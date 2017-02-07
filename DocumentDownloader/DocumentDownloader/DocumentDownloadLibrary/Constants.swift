//
//  Constants.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

typealias DOCUMENTCOMPLETION = (String?, Bool, Bool) -> Void
var maximumConcurrentDownloads: Int = 3 // concurrent downloads
var loadingTimeout: TimeInterval = 60.0 // timeout for files
var thresholdMemorySize: UInt64 = 30 // in mb
