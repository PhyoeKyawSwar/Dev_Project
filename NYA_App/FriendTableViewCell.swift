//
//  FriendTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 18/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var imgSp: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnAddFriend: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data : User , fromView : String)
    {
        if fromView == "Friend"
        {
            self.btnAddFriend.isHidden = false
            self.lblDistance.isHidden = true
            
        }
        else
        {
            self.btnAddFriend.isHidden = true
            self.lblDistance.isHidden = false
        }
        
        print("profile ##### " ,data.profile_picture)
        if data.profile_picture.contains("/storage")
        {
            self.imgUser.setUserimage(url_string: "\(image_url_host)\(data.profile_picture)")
            
        }
        else
        {
            self.imgUser.setUserimage(url_string: data.profile_picture)
            
        }
        self.lblName.setNormalLabel(text: "\(data.name)", color: BLACK_COLOR, size: 18.0, font_name: BOLD_FONT)
        self.lblBio.setNormalLabel(text: "\(data.bio)", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
       // self.lblBio.setNormalLabel(text: "lskadfjsaoldkfjsadifksdfj iodskfjasdlfkj ldsifokjsadfjadsif sdkfjasldfkjasdfk isadfjaskldfj alfsd idslkfjsadfk j", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        self.lblDistance.setNormalLabel(text: "\(data.distance) KM", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
       
        self.imgSp.backgroundColor = GRAY_COLOR
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
