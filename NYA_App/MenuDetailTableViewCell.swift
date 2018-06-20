//
//  MenuDetailTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 26/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class MenuDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgSp: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func operateMenuData (dataDict : Menu)
    {
        self.imgMenu.setimage(url_string: "\(image_url_host)\(dataDict.image)")
        self.lblName.setNormalLabel(text: dataDict.name, color: BLACK_COLOR, size: 18.0, font_name: BOLD_FONT)
        self.lblPrice.setNormalLabel(text: "Ks \(dataDict.price)", color: BOTTOM_COLOR, size: 10.0, font_name: LIGHT_FONT)
        self.lblDesc.setNormalLabel(text: dataDict.desc, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        self.imgSp.backgroundColor = GRAY_COLOR
    }

}
