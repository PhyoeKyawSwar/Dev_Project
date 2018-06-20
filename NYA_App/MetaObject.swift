//
//  MetoObject.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 2/12/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class MetaObject: NSObject {

    var current_page = Int()
    var from = Int()
    var last_page = Int()
    var path = String()
    var per_page = Int()
    var to = Int()
    var total = Int()
    
    func operateData (dataDict : Dictionary<String,Any>) -> MetaObject
    {
        if let current = dataDict["current_page"] as? Int
        {
            self.current_page = current
        }
        if let from = dataDict["from"] as? Int
        {
            self.from = from
        }
        if let last = dataDict["last_page"] as? Int
        {
            self.last_page = last
        }
        if let path = dataDict["path"] as? String
        {
            self.path = path
        }
        if let per = dataDict["per_page"] as? Int
        {
            self.per_page = per
        }
        if let to = dataDict["to"] as? Int
        {
            self.to = to
        }
        if let total = dataDict["total"] as? Int
        {
            self.total = total
        }
        
        return self
        
    }
}
