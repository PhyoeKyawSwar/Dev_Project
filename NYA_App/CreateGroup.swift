//
//  CreateGroup.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 6/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class CreateGroup: NSObject {
/*
     "date_time" = "2018-02-07 20:31:01";
     "group_chat_id" = 10;
     id = 7;
     "privacy_id" = 1;
     "shop_id" = 7;
     "unique_string" = 5a79b532727d5;
 */
    var date_time = String()
    var group_chat_id = Int()
    var id = Int()
    var privacy_id = Int()
    var shop_id = Int()
    var unique_string = String()
    
    /*init(date_time : String , group_chat_id : Int , id : Int , privacy_id : Int , shop_id : Int , unique_string : String) {
        self.date_time = date_time
        self.group_chat_id = group_chat_id
        self.id = id
        self.privacy_id = privacy_id
        self.shop_id = shop_id
        self.unique_string = unique_string
    }
    */
    func operateData (data_dict : Dictionary<String , Any>) -> CreateGroup
    {
        self.date_time = data_dict["date_time"] as? String ?? ""
        self.group_chat_id = data_dict["group_chat_id"] as? Int ?? 0
        self.id = data_dict["id"] as? Int ?? 0
        self.privacy_id = data_dict["privacy_id"] as? Int ?? 0
        self.shop_id = data_dict["shop_id"] as? Int ?? 0
        self.unique_string = data_dict["unique_string"] as? String ?? ""
        
        return self
    }
}
