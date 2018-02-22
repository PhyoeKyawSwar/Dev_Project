//
//  AlertViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 10/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class AlertViewController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func loadingAlert(title : String,message : String) -> UIAlertController {
        let imagineAlertController = UIAlertController(title: title ,message : "\(message)... \n", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.darkGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        imagineAlertController.view.addSubview(indicator)
        
        let views = ["pending" : imagineAlertController.view,"indicator" : indicator]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[indicator]-(7)-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        imagineAlertController.view.addConstraints(constraints)
        
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        return imagineAlertController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
