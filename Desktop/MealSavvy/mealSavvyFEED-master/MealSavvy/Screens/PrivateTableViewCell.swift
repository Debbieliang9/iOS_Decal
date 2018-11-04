//
//  PrivateTableViewCell.swift
//  MealSavvy
//
//  Created by Eric Le Ge on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class PrivateTableViewCell: UITableViewCell {

    weak var delegate: PrivateTableViewCellDelegate?
    @IBOutlet weak var mySwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol PrivateTableViewCellDelegate : class {
    func PrivateTableViewCellDidTapSwitch(_ sender: PrivateTableViewCell)
}
