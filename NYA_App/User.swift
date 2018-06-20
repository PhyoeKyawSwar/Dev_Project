//
//  User.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 23/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class User: NSObject {

    var id = Int()
    var name = String()
    var user_name = String()
    var provider_id = String()
    var profile_picture = String()
    var mobile = String()
    var bio = String()
    var friend_status = String()
    var follow_status = Bool()
    var reviews = Int()
    var followers = Int()
    var polls = Int()
    var distance = Float()
    var images = [FeaturedImage]()
    var unique_string = String()
    func operateUserData(dataDict : Dictionary<String,Any>) -> User
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.user_name = dataDict["user_name"] as? String ?? ""
        self.provider_id = dataDict["provider_id"] as? String ?? ""
        self.profile_picture = dataDict["profile_picture"] as? String ?? ""
        self.mobile = dataDict["mobile"] as? String ?? ""
        self.bio = dataDict["bio"] as? String ?? ""
        self.friend_status = dataDict["friend_status"] as? String ?? ""
        //self.follow_status = dataDict["follow_status"] as! String
        self.distance = dataDict["distance"] as? Float ?? 0.00
        self.reviews = dataDict["reviews"] as? Int ?? 0
        self.followers = dataDict["followers"] as? Int ?? 0
        self.polls = dataDict["polls"] as? Int ?? 0
        self.unique_string = dataDict["unique_string"] as? String ?? ""
        if let image_array = dataDict["images"] as? [Dictionary<String,Any>]
        {
            for image in image_array
            {
                let feature_image = FeaturedImage.init(id: image["id"] as! Int, user_id: image["user_id"] as! Int, image: image["image"] as? String ?? "")
                self.images.append(feature_image)
                
            }
        }
        
        return self
    }
    
}
