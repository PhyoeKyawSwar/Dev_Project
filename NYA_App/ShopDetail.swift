//
//  ShopDetail.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 24/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class ShopDetail: NSObject {

    var id = Int()
    var name = String()
    var cover_photo = String()
    var profile_photo = String()
    var address = String()
    var opening_hour = String()
    var shop_group_id = Int()
    var website = String()
    var lat = Float()
    var lng = Float()
    var is_subscribe = Bool()
    var is_going = Bool()
    var polls = Int()
    var phone_no = String()
    var brief_review = BriefReview()
   // var customer_review = []()
    //var menu =
    var most_popular = [Menu]()
    var environment = [Environment]()
    var opening_hour_detail = [OpeningTime]()
    
    func operateData(dataDict : Dictionary<String,Any>) -> ShopDetail
    {
        self.id = dataDict["id"] as? Int ?? 0
        self.name = dataDict["name"] as? String ?? ""
        self.cover_photo = dataDict["cover_photo"] as? String ?? ""
        self.profile_photo = dataDict["profile_photo"] as? String ?? ""
        self.address = dataDict["address"] as? String ?? ""
        self.opening_hour = dataDict["opening_hour"] as? String ?? ""
        self.website = dataDict["website"] as? String ?? ""
        self.lat = dataDict["lat"] as? Float ?? 0.0
        self.lng = dataDict["lng"] as? Float ?? 0.0
        self.is_subscribe = dataDict["is_subscribe"] as? Bool ?? false
        self.is_going = dataDict["is_going"] as? Bool ?? false
        self.polls = dataDict["polls"] as? Int ?? 0
        self.phone_no = dataDict["phone_no"] as? String ?? ""
        self.shop_group_id = dataDict["shop_group_id"] as? Int ?? 0
      
        if let review = dataDict["brief_review"] as? Dictionary<String,Any>
        {
            let brief = BriefReview()
            self.brief_review = brief.operateData(dataDict: review)
        }
        if let menu = dataDict["menus"] as? Dictionary<String,Any>
        {
            if let popular = menu["Most Popular"] as? [Dictionary<String,Any>]
            {
                let obj_menu = Menu()
                self.most_popular = obj_menu.operateData(dataDict: popular)
            }
        }
        
        if let env = dataDict["environment"] as? [Dictionary<String,Any>]
        {
            let e = Environment()
            self.environment = e.operateData(dataDict: env)
        }
        
        if let open_time = dataDict["opening_hour_detail"] as? [Dictionary<String,Any>]
        {
            let open = OpeningTime()
            self.opening_hour_detail = open.operateData(dataDict: open_time)
        }
        
        return self
        
        
    }
}

/*
 "id": 1,
 "name": "Lotteria",
 "cover_photo": "/storage/images/shop/cover_photo/zhlTmoSis5i7kep40OIhcX63cosFEefoAEARi42t.jpeg",
 "profile_photo": "/storage/images/shop/profile_photo/ox85Ay40ohvHspo1xMyFvPMLpOOPXZkt63YyMahG.jpeg",
 "address": "Yangon, Myanmar",
 "opening_hour": "11 AM - 12 AM",
 "website": "lotteria.com",
 "lat": 16.827793,
 "lng": 96.155902,
 "is_subscribe": true,
 "is_going": true,
 "polls": 10,
 "brief_review": {
 "total": 0,
 "rating": 0
 },
 "customer_reviews": [],
 "menus": {
 "Most Popular": [
 {
 "id": 1,
 "name": "Chicken",
 "image": "/storage/images/shop/menu_image/e9kvzPYPzkmKb7CF2GUhi5zIgSNjlIfDaPffo60l.jpeg",
 "price": "3000.00",
 "description": "Fresh and delicious"
 }
 ]
 },
 "environments": [
 {
 "id": 1,
 "image": "/storage/images/shop/env_image/sFnOqjHEh7sDdGhIfKf03gki296qFLh65Gs2U6Xl.jpeg"
 }
 ]
 */
