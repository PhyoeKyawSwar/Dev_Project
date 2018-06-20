//
//  PreviousReviewShop.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 17/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class PreviousReviewShop: NSObject {
    /*
     "id": 10,
     "name": "PKS",
     "description": "This is very very good",
     "rating": 5,
     "images": []
     "shop_id": 1,
     "shop": "Harry’s Bar (Myanmar Plaza)",
     "shop_profile_photo": "/storage/images/shop/profile_photo/mOt0Fil0kfPZ2av7Egv7tqLfIBWhcECOaElBJT31.jpeg",
 */
    var id = Int()
    var name = String()
    var desc = String()
    var rating = Float()
    var shop_id = Int()
    var shop_name = String()
    var shop_profile_photo = String()
    
    func operateData(dataDict : Dictionary<String,Any>) -> PreviousReviewShop
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.desc = dataDict["description"] as? String ?? ""
        self.rating = dataDict["rating"] as? Float ?? 0.00
        self.shop_id = dataDict["shop_id"] as? Int ?? 0
        self.shop_name = dataDict["shop"] as? String ?? ""
        self.shop_profile_photo = dataDict["shop_profile_photo"] as? String ?? ""
        return self
        
    }
}
