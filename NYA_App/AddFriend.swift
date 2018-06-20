//
//  AddFriend.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 24/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class AddFriend: NSObject {
/*
 "data": {
 "friend_status": "pending",
 "following": true
 }
 */
    
    var friend_status = String()
    var follow = Bool()
    
    func operateData(dictData : Dictionary<String,Any>) -> AddFriend
    {
        self.friend_status = dictData["friend_status"] as? String ?? ""
        self.follow = dictData["following"] as? Bool ?? false
        
        return self
    }
}
