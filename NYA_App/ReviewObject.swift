//
//  ReviewObject.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 3/12/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class ReviewObject: NSObject {
    var id = Int()
    var name = String()
    var profile_picture = String()
    var rating = Int()
    var desc = String()
    var images = [String]()
    
    func operateData (dataDict : [Dictionary<String,Any>]) -> [ReviewObject]
    {
        var temp = [ReviewObject]()
        
        for dict in dataDict
        {
            var obj = ReviewObject()
            
            obj.id = dict["id"] as? Int ?? 0
            obj.name = dict["name"] as? String ?? ""
            obj.profile_picture = dict["profile_picture"] as? String ?? ""
            obj.rating = dict["rating"] as? Int ?? 0
            obj.desc = dict["description"] as? String ?? ""
            obj.images = dict["images"] as? [String] ?? []
            
            temp.append(obj)
        }
        
        return temp
    }
}
