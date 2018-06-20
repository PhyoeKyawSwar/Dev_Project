//
//  PreviousReviewMenu.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 17/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class PreviousReviewMenu: NSObject {
    /*
     "menu_id": 1,
     "menu_name": "Kettle chips",
     "menu_image": "/storage/images/shop/menu_image/EGWuMOZSh0TRGzM7ItXtoCq2oyHBkCAOoEbvlEOE.jpeg",
 */
    
    var id = Int()
    var name = String()
    var shop_id = Int()
    var shop_name = String()
    var desc = String()
    var rating = Float()
    var menu_id = Int()
    var menu_name = String()
    var menu_image = String()
    
    func operateData(dataDict : Dictionary<String,Any>) -> PreviousReviewMenu
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.shop_id = dataDict["shop_id"] as? Int ?? 0
        self.shop_name = dataDict["shop_name"] as? String ?? ""
        self.desc = dataDict["description"] as? String ?? ""
        self.rating = dataDict["rating"] as? Float ?? 0.00
        self.menu_id = dataDict["menu_id"] as? Int ?? 0
        self.menu_name = dataDict["menu_name"] as? String ?? ""
        self.menu_image = dataDict["menu_image"] as? String ?? ""
        
        return self
        
    }
}
