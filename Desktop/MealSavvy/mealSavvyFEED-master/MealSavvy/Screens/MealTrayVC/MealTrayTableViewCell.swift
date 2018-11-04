//
//  MealTrayTableViewCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 10/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

protocol MealTrayTableViewCellDelegate: class {
    func onRemove(_ cellIndex:Int!)
}

class MealTrayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dishImgView: UIImageView!
    @IBOutlet weak var dishTitle: UILabel!
    @IBOutlet weak var lblRestaurant: UILabel!
    @IBOutlet weak var imgToken: UIImageView!
    @IBOutlet weak var lblTokenCount: UILabel!
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var imgRemove: UIImageView!
    
    var cellIndex:Int!
    weak var delegate: MealTrayTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let removeTap = UITapGestureRecognizer(target: self, action: #selector(self.onRemove))
        self.imgRemove.addGestureRecognizer(removeTap)
    }
    
    @objc func onRemove() {
        delegate?.onRemove(cellIndex)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(foodDetail: ServiceModel, tokenPay:Bool){
        if tokenPay == true{
            imgToken.isHidden = false
            lblToken.isHidden = false
            let tokens  = foodDetail.tokens
            lblTokenCount.text = tokens
        }
        else {
            imgToken.isHidden = true
            lblToken.isHidden = true
            let normalPrice = foodDetail.normalPrice!
            let price = foodDetail.price!
            lblTokenCount.text = "$\(String(format: "%.2f", price))"
        }
        
        dishImgView.image  = nil
        dishImgView.af_setImage(withURL: URL.init(string: foodDetail.image)!)
        dishTitle.text = foodDetail.name!
        dishTitle.frame = CGRect(x: dishTitle.frame.origin.x, y: dishTitle.frame.origin.y, width: 100, height: dishTitle.frame.size.height)
        lblRestaurant.text = foodDetail.supplierName!
    }
}
