//
//  NearShop.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 17/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class NearShop: NSObject {
/*
     "id": 4,
     "name": "Inya Kanbaung(Pyay Road)",
     "lat": 16.827271,
     "lng": 96.134859,
     "address": "Pyay Road,Inya Kanbaung",
     "distance": 1
 */
    var id = Int()
    var name = String()
    var lat = Double()
    var lng = Double()
    var address = String()
    var distance = Float()
    
    func operateData(dataDict : Dictionary<String,Any>) -> NearShop
    {
        self.id = dataDict["id"] as! Int
        self.name = dataDict["name"] as? String ?? ""
        self.lat = dataDict["lat"] as? Double ?? 0.000000
        self.lng = dataDict["lng"] as? Double ?? 0.000000
        self.address = dataDict["address"] as? String ?? ""
        self.distance = dataDict["distance"] as? Float ?? 0.00
        
        return self
        
    }
    
}
