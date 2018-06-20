//
//  Menu.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 24/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class Menu: NSObject {
/*
     "id": 1,
     "name": "Chicken",
     "image": "/storage/images/shop/menu_image/e9kvzPYPzkmKb7CF2GUhi5zIgSNjlIfDaPffo60l.jpeg",
     "price": "3000.00",
     "description": "Fresh and delicious"
 */
    var id = Int()
    var name = String()
    var image = String()
    var price = String()
    var desc = String()
    
    func operateData (dataDict : [Dictionary<String,Any>]) -> [Menu]
    {
        var temp = [Menu]()
        
        for dict in dataDict
        {
            self.id = dict["id"] as? Int ?? 0
            self.name = dict["name"] as? String ?? ""
            self.image = dict["image"] as? String ?? ""
            self.price = dict["price"] as? String ?? ""
            self.desc = dict["description"] as? String ?? ""
            
            temp.append(self)
        }
       
        return temp
    }
}
