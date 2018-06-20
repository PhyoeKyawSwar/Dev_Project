//
//  Category.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 23/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id = Int()
    var name = String()
    var image = String()

    func operateCategory(dataDict : Dictionary<String,Any>) -> Category
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.image = dataDict["image"] as? String ?? ""
        return self
        
    }
}
