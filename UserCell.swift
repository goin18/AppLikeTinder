//
//  UserCell.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 04/09/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
