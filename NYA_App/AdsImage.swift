//
//  AdsImage.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 23/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class AdsImage: NSObject {

    var id = Int()
    var image = String()
    var shopID = Int()
    
    func operateAdsImage (dataDict : Dictionary<String,Any>) -> AdsImage
    {
        self.id = dataDict["id"] as! Int
        self.image = dataDict["image"] as? String ?? ""
        self.shopID = dataDict["shop_id"] as? Int ?? 0
        
        return self
    }
}
