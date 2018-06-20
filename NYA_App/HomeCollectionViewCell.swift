//
//  CollectionViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 22/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//




import UIKit
import SDWebImage
class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddFriend : UILabel!
    @IBOutlet weak var bgView: UIView!
    
    func setShadow()
    {
        self.bgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.shadowOffset = CGSize.zero
        self.bgView.layer.shadowRadius = 2
        self.bgView.layer.cornerRadius = 5
        
        
    }
    func setCollectionData(category :Category)
    {
       // print("Image url",category[IMAGE] as! String)
        //self.imgIcon.sd_setImage(with: URL(string: category[IMAGE] as! String), placeholderImage: UIImage(named: "placeholder_image"))
        self.imgIcon.setimage(url_string: "\(image_url_host)\(category.image)")
        self.lblTitle.textColor = GRAY_COLOR
        self.lblTitle.text = category.name 
        //self.lblTitle.font = UIFont(name: THIN_FONT, size: 11.0)
        self.lblAddFriend.isHidden = true
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
