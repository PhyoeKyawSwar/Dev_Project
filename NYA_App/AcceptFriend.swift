//
//  AcceptFriend.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class AcceptFriend: NSObject {
    /*"friend_status": "confirmed",
     "following": true,
     "sender_unique_string": "5a7eae301005b",
     "unique_string": "5a86f6ccc94b8"
 */
    var friend_status = String()
    var following = Bool()
    var sender_unique_string = String()
    var unique_string = String()
    
    func operateUserData(dataDict : Dictionary<String,Any>) -> AcceptFriend
    {
        self.friend_status = dataDict["friend_status"] as? String ?? ""
        self.following = dataDict["following"] as? Bool ?? false
        self.sender_unique_string = dataDict["sender_unique_string"] as? String ?? ""
        self.unique_string = dataDict["unique_string"] as? String ?? ""
        
        
        return self
    }
    
}
