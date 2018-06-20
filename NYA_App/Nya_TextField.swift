//
//  Nya_TextField.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 21/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import UIKit


extension UITextField
{
    func setNormalTextFieldLayout ()
    {
        self.layer.cornerRadius = 25
        self.layer.borderColor = GRAY_COLOR.cgColor
        self.layer.borderWidth = 1
        
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        self.leftView = leftpaddingView
        self.leftViewMode = .always
    }
    
    
    func setChatTextFieldLayout (placeholder : String)
    {
        self.layer.cornerRadius = 5
        self.layer.borderColor = GRAY_COLOR.cgColor
        self.layer.borderWidth = 1
        self.placeholder = placeholder
        self.autocorrectionType = .no
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = leftpaddingView
        self.leftViewMode = .always
    }
    
    func setPasswordTextFieldLayout ()
    {
        self.layer.cornerRadius = 25
        self.layer.borderColor = GRAY_COLOR.cgColor
        self.layer.borderWidth = 1
        
        let rightpaddingView = UIView(frame: CGRect(x: 0, y: self.frame.size.width - 80, width: 80, height: 50))
        
        let btnForgot = UIButton(frame: CGRect(x: 0, y: self.frame.size.width - 80, width: 80, height: 50))
        btnForgot.setTitle("Forgetten", for: .normal)
        btnForgot.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        rightpaddingView.addSubview(btnForgot)
        
        self.rightView = rightpaddingView
        self.rightViewMode = .always
        
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        self.leftView = leftpaddingView
        self.leftViewMode = .always
        
    }
    
    func setSearchTextFieldLayout ()
    {
        self.layer.cornerRadius = 5
        self.layer.borderColor = GRAY_COLOR.cgColor
        self.layer.borderWidth = 1
        
        self.placeholder = "Search"
        
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let imgView = UIImageView(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
        imgView.image = #imageLiteral(resourceName: "search")
        
        leftpaddingView.addSubview(imgView)
        
        self.leftView = leftpaddingView
        self.leftViewMode = .always
        
        self.tintColor = PINK_COLOR
    }
}


