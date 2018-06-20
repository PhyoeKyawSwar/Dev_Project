//
//  Event.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 23/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class Event: NSObject {
/*
     "id": 1,
     "name": "Buy One Get One Free",
     "image": "/storage/images/event/wptgQXs5Md8AYkDpD6Q0AfCFp3f1L4P5faz8158a.jpeg",
     "description": "Lotteria Special Promotion",
     "timeline": "26-27 Nov at 6-9 PM"
 */
    
    var id = Int()
    var name = String()
    var image = String()
    var desc = String()
    var timeline = String()
    
    func operateEvent(dataDict : Dictionary<String,Any>) -> Event
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.image = dataDict["image"] as? String ?? ""
        self.desc = dataDict["description"] as? String ?? ""
        self.timeline = dataDict["timeline"] as? String ?? ""
        
        return self
        
    }
}
