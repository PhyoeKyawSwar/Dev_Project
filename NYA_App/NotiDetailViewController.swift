//
//  NotiDetailViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 4/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class NotiDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    var detailDict = [String : Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

       // let dict = detailDict["data"] as! [String : Any]
        lblTitle.text = detailDict["title"] as! String
        lblTitle.font = UIFont(name: BLACK_FONT, size: NORMAL_FONT_SIZE)
        
        lblMessage.text = detailDict["message"] as! String
        lblMessage.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
        lblMessage.textColor = LIGHT_GRAY_COLOR
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
