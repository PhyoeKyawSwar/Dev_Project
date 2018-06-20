//
//  Environment.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 24/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class Environment: NSObject {

    var id = Int()
    var image = String()
    
    func operateData(dataDict : [Dictionary<String,Any>]) -> [Environment]
    {
        var temp = [Environment]()
        
        for dict in dataDict
        {
            self.id = dict["id"] as? Int ?? 0
            self.image = dict["image"] as? String ?? ""
            temp.append(self)
            
        }
        
        return temp
    }
}
