//
//  ReviewTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 12/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import SDWebImage
import HCSStarRatingView
class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReviewText: UILabel!
    @IBOutlet weak var reviewCollection: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var imgSp: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupData(dict : ReviewObject)
    {
      
        print("Review :::::",dict.desc)
        self.imgProfile.layer.cornerRadius = 20
        self.imgProfile.clipsToBounds = true
        if dict.profile_picture.contains("/storage")
        {
            self.imgProfile.setUserimage(url_string: "\(image_url_host)\(dict.profile_picture)")
            
        }
        else
        {
            self.imgProfile.setUserimage(url_string: "\(dict.profile_picture)")
            
        }
        
        if dict.images.count > 0
        {
            self.collectionHeight.constant = 80
           
        }
        else
        {
            self.collectionHeight.constant = 0
        }
        self.lblName.setNormalLabel(text: dict.name, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        self.lblReviewText.setNormalLabel(text: dict.desc, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        self.ratingView.value = CGFloat(dict.rating)
        
        self.ratingView.isUserInteractionEnabled = false
        imgSp.backgroundColor = UIColor.lightGray
    }
}


