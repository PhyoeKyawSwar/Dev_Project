//
//  FriendRequest.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
class FriendRequest: NSObject {
    
    var id = Int()
    var name = String()
    var user_name = String()
    var profile_picture = String()
   
    func operateUserData(dataDict : Dictionary<String,Any>) -> FriendRequest
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.user_name = dataDict["user_name"] as? String ?? ""
        self.profile_picture = dataDict["profile_picture"] as? String ?? ""
       
        
        return self
    }
    
}
