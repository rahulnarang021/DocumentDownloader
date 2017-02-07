//
//  NetworkingManager.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit


enum Method: String {
    case GET, HEAD, POST, PUT, PATCH, DELETE
}

class NetworkingManager: NSObject {
    static let sharedManager = NetworkingManager()

    let timeout:TimeInterval = 15.0
    var session:URLSession = URLSession(configuration: URLSessionConfiguration.default)

    //MARK: - Perform Request
    func performRequest(_ url:String,requestMethod:Method, parameters:Dictionary<String,AnyObject>?, success:@escaping ((AnyObject?) -> Void), failure:@escaping (()->())) {
        
        var request:URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = requestMethod.rawValue
        if let params = parameters, requestMethod == .POST {
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch let error {
                print("error attaching to http body \(error)")
            }
        }
        self.session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            DispatchQueue.main.async(execute: {
                
                if let responseData = data {
                    do {
                        let json:AnyObject? = try JSONSerialization.jsonObject(with: responseData) as AnyObject
                        success(json)
                    }
                    catch {
                        failure()
                    }
                }
                else{
                    failure()
                }
            })
        }.resume()
    }
}
