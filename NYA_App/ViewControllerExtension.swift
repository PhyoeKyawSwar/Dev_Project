//
//  ViewControllerExtension.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 10/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    
    func setBackButton ()
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.gotoBack))
        
    }
    
    func gotoBack ()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showLoading(alertInitiate : Bool,title : String,message : String) -> UIAlertController?
    {
        if alertInitiate{
            let alert : UIAlertController  = AlertViewController.loadingAlert(title: title, message: "\(message)")
            self.present(alert, animated: true, completion: nil)
            return alert
            
        }
        return nil
        
    }
    
    /* func setUpNavTitleConfiguration(){
     
     guard let nav = self.navigationController else{
     return
     }
     
     nav.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: BOLD_FONT, size: 17)!,NSForegroundColorAttributeName: UIColor.white]
     
     }
     */
    
}

extension UINavigationController
{
    func setBackbuttonTitle ()
    {
        self.navigationBar.backItem?.title = ""
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
