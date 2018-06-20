//
//  ChatTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 27/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIncomingMessage: UILabel!
    @IBOutlet weak var lblOutgoingMessage: UILabel!
    @IBOutlet weak var btnVote: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
