//
//  CommentViewCell.swift
//  MealSavvy
//
//  Created by CiCi on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    @IBOutlet var commentuserphoto: UIImageView!
    
    @IBOutlet var commentername: UILabel!
    
    @IBOutlet var commentmessage: UILabel!

    @IBOutlet var commenttimeago: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
