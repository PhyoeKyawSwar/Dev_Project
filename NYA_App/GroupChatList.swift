//
//  GroupChatList.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 6/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class GroupChatList: NSObject {
/*
     id = 3;
     name = "Shop Going Guys";
     type = 1;
     "unique_string" = 5a7535d1c5d06;
     "user_id" = 5;
 */
    var id = Int()
    var name = String()
    var type = Int()
    var unique_string = String()
    var user_id = Int()
    
   /* init (id : Int , name :String , type : Int , unique_string : String , user_id : Int)
    {
        self.id = id
        self.name = name
        self.type = type
        self.unique_string = unique_string
        self.user_id = user_id
    }
 */
    
    func operateDate (dict : Dictionary<String , Any>) -> GroupChatList
    {
       
            self.id = dict["id"] as? Int ?? 0
            self.name = dict["name"] as? String ?? ""
            self.type = dict["type"] as? Int ?? 0
            self.unique_string = dict["unique_string"] as? String ?? ""
            self.user_id = dict["user_id"] as? Int ?? 0
        
        return self
    }
}
