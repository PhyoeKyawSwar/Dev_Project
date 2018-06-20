//
//  Review.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 24/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class BriefReview: NSObject {

    var total = Int()
    var rating = Float()
    
    func operateData (dataDict : Dictionary<String,Any>) -> BriefReview
    {
        self.total = dataDict["total"] as? Int ?? 0
        self.rating = dataDict["rating"] as? Float ?? 0.0
        
        return self
    }
}
