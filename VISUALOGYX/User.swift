//
//  User.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/9/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import Foundation

class User {
    static let typeManager = "manager"
    
    var username : String?
    var userType : String?
    var jobTitle : String?
    var email : String?
    var phone : String?
    var avatar : String?
    var thumb : String?
    
    init(response: [String : AnyObject]?) {
        if let user = response {
            username = user["user_name"] as? String
            userType = user["user_type"] as? String
            jobTitle = user["job_title"] as? String
            email = user["email"] as? String
            phone = user["phone_number"] as? String
            avatar = user["image_data"] as? String
            thumb = user["image_thumb_data"] as? String
            
            if let profile = user["profile_image"] as? [String : AnyObject] {
                avatar = profile["url"] as? String
                if let thumbObj = profile["thumb"] as? [String : String] {
                    thumb = thumbObj["url"]
                }
            }
        }
    }
}
