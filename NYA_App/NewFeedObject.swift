//
//  NewFeedObject.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 7/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class NewFeedObject: NSObject {

    /*
     {
     "id": 5,
     "event_id": 1,
     "group_name": "Event Going Guys",
     "going_count": 0,
     "going_users": [],
     "event_name": "Thank Harry's It Friday",
     "date_time": "2018-01-17 23:00:41"
     },
     {
     "id": 6,
     "group_name": "Shop Going Guys",
     "going_count": 0,
     "going_users": [],
     "going_places": [
     {
     "id": 4,
     "name": "Harry’s Bar (Myanmar Plaza)"
     }
     ],
     "date_time": "2018-01-17 23:00:41"
     }
 */
    var id = Int()
    var event_id = Int()
    var group_name = String()
    var going_count = Int()
    var going_user = [[String : Any]]()
    var event_name = String()
    var date_time = String()
    var going_place = [Dictionary<String,Any>]()
    
    func operateData(dictionary : Dictionary<String , Any>) -> NewFeedObject
    {
        self.going_place = [Dictionary<String,Any>] ()
        self.event_id = 0
        self.event_name = ""
        for key in dictionary.keys
        {
            if key == "going_places"
            {
                self.going_place = (dictionary["going_places"] as? [Dictionary<String,Any>])!
                
            }
            if key == "event_id"
            {
                self.event_id = dictionary["event_id"] as? Int ?? 0
                
            }
            if key == "event_name"
            {
                    self.event_name = dictionary["event_name"] as? String ?? ""
                    
            }
            
        }
        self.id = dictionary["id"] as? Int ?? 0
        self.group_name = dictionary["group_name"] as? String ?? ""
        self.going_count = dictionary["going_count"] as? Int ?? 0
        self.going_user = (dictionary["going_users"] as? [[String : Any]])!
        self.date_time = dictionary["date_time"] as? String ?? ""
        
        
        return self
    }
}
