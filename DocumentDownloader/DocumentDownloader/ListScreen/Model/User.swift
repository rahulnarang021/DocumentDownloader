//
//  User.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/5/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

class User: NSObject {
    var userId: String?
    var userName: String?
    var name: String?
    var profileImage: Dictionary<String, String>?
    
    // MARK: - Initialize User
    init(dictUser: Dictionary<String, AnyObject>) {
        self.userId = dictUser["id"] as? String
        self.userName = dictUser["username"] as? String
        self.name = dictUser["name"] as? String
        self.profileImage = dictUser["profile_image"] as? Dictionary<String, String>
    }
    
    // MARK: - API Call To Fetch Users
    class func callAPIToFetchUsers(completion: @escaping ([User]?) -> ()) {
           let urlStr = "http://pastebin.com/raw/wgkJgazE"
        NetworkingManager.sharedManager.performRequest(urlStr, requestMethod: .GET, parameters: nil, success: { (objResponse: AnyObject?) in
            var arrayUsers: [User] = []
            if let arrayResponse: [[String:AnyObject]] = objResponse as? [[String:AnyObject]] {
                arrayResponse.forEach({ (dictResponse: [String : AnyObject]) in
                    if let dictUser: [String : AnyObject] = dictResponse["user"] as? [String : AnyObject] {
                        arrayUsers.append(User(dictUser: dictUser))
                    }
             })
                completion(arrayUsers)
            }
        }) {
            completion(nil)
        }
    }
    
    // MARK: - Getters For Models
    func getUserImageUrl() -> String? {
        if let dictImage = self.profileImage {
            return dictImage["large"]
        }
        return nil
    }
}
