//
//  PaymentVCTableViewCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class PaymentVCTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgModeImage: UIImageView!
    @IBOutlet weak var viewOverAll: UIView!
    @IBOutlet weak var lblMode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func putDataIntoCell(data: Dictionary<String,String>){
        imgModeImage.image = UIImage.init(named: data["image"]!)
        lblMode.text = data["name"]
        viewOverAll.addShadowWithRadius(radius: 2, cornerRadius: 5)
    }
}
