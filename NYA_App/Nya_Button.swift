//
//  Nya_Button.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
extension UIButton
{
    func setButtonLayout(color : UIColor , title : String)
    {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 25
        self.layer.borderColor = color.cgColor
        self.setTitleColor(color, for: .normal)
        self.setTitle(title, for: .normal)

    }
    
    func animate() {
        
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }

}
