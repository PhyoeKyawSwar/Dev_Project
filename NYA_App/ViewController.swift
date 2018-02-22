//
//  ViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 19/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblImprove: UILabel!
    @IBOutlet weak var lblCopyRight: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
        
        lblImprove.text = "improving your lifestyle"
        lblImprove.font = UIFont(name: ITALIC_FONT, size: TITLE_FONT_SIZE)
        if lblImprove.applyGradientWith(startColor: TOP_COLOR, endColor: BOTTOM_COLOR)
        {
            print("Gradiant apply")
        }
        else
        {
            print("no Gradiant apply")
        }
        
        lblCopyRight.setNormalLabel(text: "© nya.com.mm", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        self.perform(#selector(self.gotoLoginPage), with: nil, afterDelay: 2.0)
        
    }
    
    func gotoLoginPage()
    {
      
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
         self.present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

