//
//  EventDetail.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 23/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class EventDetail: NSObject {
/*
     [
     "timeline": 26-27 Nov at 6-9 PM,
     "name": Buy One Get One Free,
     "is_going": 0,
     "interest_count": 100,
     "address": ,
     "description": Lotteria Special Promotion,
     "is_interest": 1,
     "id": 1,
     "going_count": 100,
     "image": /storage/images/event/wptgQXs5Md8AYkDpD6Q0AfCFp3f1L4P5faz8158a.jpeg,
     "event_date": <null>,
     "brief_review": {
     rating = 4;
     total = 2;
     },
     "opening": 9 AM - 9 PM,
     "shop_info": {
     address = "Yangon, Myanmar";
     id = 1;
     name = Lotteria;
     "opening_hour" = "11 AM - 12 AM";
     "profile_photo" = "/storage/images/shop/profile_photo/ox85Ay40ohvHspo1xMyFvPMLpOOPXZkt63YyMahG.jpeg";
     }]
 */
    
    var timeline = String()
    var name = String()
    var is_going = Int()
    var interest_count = Int()
    var address = String()
    var desc = String()
    var is_interest = Bool()
    var id = Int()
    var going_count = Int()
    var image = String()
    var event_date = String()
    var brief_review = BriefReview()
    var opening = String()
    var shop_info = ShopInfo()
    
    func operateData (dataDict : Dictionary <String,Any>) -> EventDetail
    {
        self.timeline = dataDict["timeline"] as? String ?? ""
        self.name = dataDict["name"] as? String ?? ""
        self.address = dataDict["address"] as? String ?? ""
        self.desc = dataDict["description"] as? String ?? ""
        self.image = dataDict["image"] as? String ?? ""
        self.event_date = dataDict["event_date"] as? String ?? ""
        self.opening = dataDict["opening"] as? String ?? ""
        self.id = dataDict["id"] as? Int ?? 0
        self.is_going = dataDict["is_going"] as? Int ?? 0
        self.interest_count = dataDict["interest_count"] as? Int ?? 0
        self.is_interest = dataDict["is_interest"] as? Bool ?? false
        self.going_count = dataDict["going_count"] as? Int ?? 0
        
        if let review = dataDict["brief_review"] as? Dictionary<String,Any>
        {
            let brief = BriefReview()
            let brief_review = brief.operateData(dataDict: review)
            self.brief_review = brief_review
        }
        
        if let shop = dataDict["shop_info"] as? Dictionary<String,Any>
        {
            let shop_info = ShopInfo()
            let shop_info_data = shop_info.operateData(dataDict: shop)
            self.shop_info = shop_info_data
        }
        
        return self
        
    }
}
