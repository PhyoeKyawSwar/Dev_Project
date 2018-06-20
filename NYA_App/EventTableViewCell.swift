//
//  EventTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 22/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import SDWebImage
class EventTableViewCell: UITableViewCell {

   // @IBOutlet weak var imgSp: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setEventData (event : Event)
    {
        self.imgLogo.setimage(url_string: "\(image_url_host)\(event.image)")
       
        self.lblDesc.text = event.desc
        self.lblDesc.textColor = GRAY_COLOR
        self.lblDesc.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)

        self.lblName.text = event.name
        self.lblName.textColor = GRAY_COLOR
        self.lblName.font = UIFont(name: BOLD_FONT, size: TITLE_FONT_SIZE)

        self.lblInfo.text = event.timeline
        self.lblInfo.textColor = GRAY_COLOR
        self.lblInfo.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)

       // self.imgSp.backgroundColor = UIColor.lightGray
    }
    
    func setShopData (event : Dictionary<String,Any>)
    {
        
        self.imgLogo.setimage(url_string: "\(image_url_host)\(event["profile_photo"] as! String)")
        self.lblDesc.text = event["opening_hour"] as? String ?? ""
        self.lblDesc.textColor = GRAY_COLOR
        self.lblDesc.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
        
        self.lblName.text = event["name"] as? String ?? ""
        self.lblName.textColor = GRAY_COLOR
        self.lblName.font = UIFont(name: BOLD_FONT, size: TITLE_FONT_SIZE)
        
        self.lblInfo.text = event["address"] as? String ?? ""
        self.lblInfo.textColor = GRAY_COLOR
        self.lblInfo.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
        
       // self.imgSp.backgroundColor = UIColor.lightGray
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
