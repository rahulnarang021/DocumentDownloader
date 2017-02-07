//
//  TestConstants.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/7/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

let testImageUrl: String = "http://www.planwallpaper.com/static/images/image-slider-2.jpg"
let testImagePath: String = Bundle.main.path(forResource: "testImage", ofType: "jpg")!
let testImageName: String = "testImage.jpg"
let testDictUser: [String:AnyObject] = ["id":"testId" as AnyObject,"username":"testName" as AnyObject,"name":"test name" as AnyObject,"profile_image":["small":testImageUrl,"large":testImageUrl,"medium":testImageUrl] as AnyObject]
