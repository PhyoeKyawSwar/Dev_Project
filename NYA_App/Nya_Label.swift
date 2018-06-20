//
//  Nya_Label.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    func setNormalLabel (text : String , color : UIColor , size : CGFloat , font_name : String)
    {
        DispatchQueue.main.async {
            self.text = text
            self.textColor = color
            self.font = UIFont(name: font_name, size: size)
        }
       
    }
}
