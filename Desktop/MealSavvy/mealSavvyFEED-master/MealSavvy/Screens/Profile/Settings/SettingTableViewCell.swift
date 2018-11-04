//
//  SettingTableViewCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    //MARK:-  IBOutlet
    @IBOutlet weak var SwitchEnable: UISwitch!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var imgModeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    //MARK:- Other Helper Methods
    func putDataIntoCell(data: Dictionary<String,String>, index: Int){
        imgModeImage.image = UIImage.init(named: data["image"]!)
        lblMode.text = data["name"]
        if index == 0 && index == 1 {
            SwitchEnable.isHidden = true
        }
        else {
            SwitchEnable.isHidden = false
        }
    }
}
