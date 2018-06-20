//
//  _BaseViewController.swift
//  EatInMyanmar
//
//  Created by Aung Htoo on 9/2/17.
//  Copyright © 2017 Creative. All rights reserved.
//

import UIKit

class _BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func showGrayBG(status : Bool)
    {
        let grayBG = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        grayBG.backgroundColor = UIColor(white: 0, alpha: 0.3)
        if status == true
        {
            grayBG.isHidden = false
        }
        else
        {
            grayBG.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- Navigation Bar [Back Button] with custom settings
    func setUpNavBarWithAttributes(navtitle : String, setStatusBarStyle : UIStatusBarStyle, isTransparent : Bool, tintColor : UIColor, titleColor : UIColor, titleFont : UIFont){
        
        navigationItem.title = navtitle
        
        UIApplication.shared.statusBarStyle = setStatusBarStyle
        
        guard let nav = self.navigationController else { return }
        
        if isTransparent{
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.isTranslucent = true
        }
        
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.barTintColor = tintColor
        nav.navigationBar.tintColor = titleColor
        nav.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: titleFont
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: titleFont
            ], for: .normal)
    }
    
    func btnBackClicked(){
        guard let nav = self.navigationController else{
            return
        }
        nav.popViewController(animated: true)
    }
    
    
    func animateViewController(nav:UINavigationController){
        
        if let window = UIApplication.shared.keyWindow {
            if let vc = nav.childViewControllers.first {
                window.rootViewController = nav
                UIView.transition(from: self.view, to: vc.view, duration: 0.6, options: [.transitionFlipFromLeft], completion: {
                    _ in
                    
                })
            }
        }
    }
}
