//
//  OrderHistoryTableViewCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 10/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    //IBOutlets
    
    @IBOutlet weak var lblFoodType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    @IBOutlet weak var viewOverAll: UIView!
    @IBOutlet weak var tokenImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Other Helper Methods
    func putDataIntoCell(data: PaymentHistoryModel){
        lblInvoiceNumber.text = String(data.transaction_hid.suffix(7))
        var date  = Date(timeIntervalSince1970: TimeInterval.init(data.time)!)
        lblDate.text = Date().convertToString("dd/MM/yyyy")
        if data.payment_method == "credit_card" {
            lblPrice.text = "$\(data.amount!)"
            tokenImgView.isHidden = true
        }
        else {
            lblPrice.text = data.tokens
            tokenImgView.isHidden = false
        }
        
        lblFoodType.text = data.service_name
        viewOverAll.addShadowWithRadius(radius: 2, cornerRadius: 5)
    }
}
