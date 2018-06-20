//
//  ShopInfo.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class ShopInfo: NSObject {
/*
     "shop_info": {
     address = "Yangon, Myanmar";
     id = 1;
     name = Lotteria;
     "opening_hour" = "11 AM - 12 AM";
     "profile_photo" = "/storage/images/shop/profile_photo/ox85Ay40ohvHspo1xMyFvPMLpOOPXZkt63YyMahG.jpeg";
     }
 */
    var id = Int()
    var address = String()
    var name = String()
    var opening_hour = String()
    var profile_photo = String()
    
    func operateData (dataDict : Dictionary<String,Any>) -> ShopInfo
    {
        self.id = dataDict["id"] as? Int ?? 0
        self.address = dataDict["address"] as? String ?? ""
        self.name = dataDict["name"] as? String ?? ""
        self.opening_hour = dataDict["opening_hour"] as? String ?? ""
        self.profile_photo = dataDict ["profile_photo"] as? String ?? ""
        
        return self
        
    }
}
