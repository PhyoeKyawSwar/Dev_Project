//
//  GoingViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 14/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class GoingViewController: UIViewController {

    @IBOutlet weak var tblFriend: UITableView!
    var going_users = [User]()
    var invited_user = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tblFriend.delegate = self
        tblFriend.dataSource = self
        tblFriend.reloadData()
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
extension GoingViewController : UITableViewDelegate , UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return self.going_users.count
        }
        else
        {
            return self.invited_user.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as! FriendTableViewCell
        
        if indexPath.section == 0
        {
            let user = going_users[indexPath.row]
            
            if user.profile_picture.contains("/storage")
            {
                cell.imgUser.setUserimage(url_string: "\(image_url_host)\(user.profile_picture)")
                
            }
            else
            {
                cell.imgUser.setUserimage(url_string: user.profile_picture)
                
            }
            
            cell.lblName.setNormalLabel(text: user.name, color: BLACK_COLOR, size: 15.0, font_name: BOLD_FONT)
            
        }
        else
        {
            let user = invited_user[indexPath.row]
            
            if user.profile_picture.contains("/storage")
            {
                cell.imgUser.setUserimage(url_string: "\(image_url_host)\(user.profile_picture)")
                
            }
            else
            {
                cell.imgUser.setUserimage(url_string: user.profile_picture)
                
            }
            
            cell.lblName.setNormalLabel(text: user.name, color: BLACK_COLOR, size: 15.0, font_name: BOLD_FONT)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Going"
        }
        else
        {
            return "Invited"
        }
    }
}
