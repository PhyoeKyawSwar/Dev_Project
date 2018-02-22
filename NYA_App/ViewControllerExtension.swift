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
