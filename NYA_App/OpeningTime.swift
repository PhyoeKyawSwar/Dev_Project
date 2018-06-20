//
//  OpeningTime.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/4/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class OpeningTime: NSObject {

    var day = String()
    var open_time = String()
    var close_time = String()
    
    func operateData(dataDict : [Dictionary<String,Any>]) -> [OpeningTime]
    {
        var temp = [OpeningTime]()
        
        for dict in dataDict
        {
            var open = OpeningTime()
            open.day = dict["day"] as? String ?? ""
            open.open_time = dict["open_time"] as? String ?? ""
            open.close_time = dict["close_time"] as? String ?? ""
            
            temp.append(open)
        }
        
        return temp
    }
}
