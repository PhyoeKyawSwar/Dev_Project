//
//  FeaturedImage.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 23/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class FeaturedImage: NSObject {

    var id = Int()
    var user_id = Int()
    var image = String()
    
    init(id : Int , user_id : Int , image :String)
    {
        self.id = id
        self.user_id = user_id
        self.image = image
    }
    
    func operateFeaturedImage(dataDict : Dictionary<String,Any>) -> FeaturedImage
    {
        self.id = dataDict["id"] as! Int
        self.user_id = dataDict["user_id"] as! Int
        self.image = dataDict["image"] as? String ?? ""
        
        return self
    }
}
