//
//  ShopGroup.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class ShopGroup: NSObject {
    var id = Int()
    var name = String()
    var image = String()
    var category_id = Int()
    
    func operateEvent(dataDict : Dictionary<String,Any>) -> ShopGroup
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.image = dataDict["image"] as? String ?? ""
      //  self.category_id = dataDict["category_id"] as! Int
        
        return self
        
    }

}
