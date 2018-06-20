//
//  NotificationViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 10/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class NotificationViewController: UIViewController {
    @IBOutlet weak var tblNoti: UITableView!
    var notiArray = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getNoti()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNoti()
    {
        
        HUD.show(.systemActivity)
        
        APIFunction.sharedInstance.apiGETMethod(method: "notifications") { (response) in
            if response.error == nil
            {
                if let data_dict = response.result as? [String : Any]
                {
                    self.notiArray = (data_dict["data"] as? [[String : Any]])!
                }
                
            }
            DispatchQueue.main.async {
                self.tblNoti.delegate = self
                self.tblNoti.dataSource = self
                self.tblNoti.reloadData()
                HUD.hide()
            }
            
        }
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

extension NotificationViewController : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiTableViewCell") as! NotiTableViewCell
        let dict = notiArray[indexPath.row]
        cell.lblTitle.setNormalLabel(text: dict["title"] as? String ?? "", color: BLACK_COLOR, size: 15.0, font_name: BOLD_FONT)
        cell.lblDesc.setNormalLabel(text: "phyokyawswar1 invited you to join going plan. phyokyawswar1 invited you to join going plan. phyokyawswar1 invited you to join going plan. phyokyawswar1 invited you to join going plan.", color: GRAY_COLOR, size: 13.0, font_name: LIGHT_FONT)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}

