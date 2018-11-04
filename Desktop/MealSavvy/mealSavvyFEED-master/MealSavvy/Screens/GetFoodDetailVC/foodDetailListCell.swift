//
//  foodDetailListCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 07/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class foodDetailListCell: UICollectionViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imgPoints2: UIImageView!
    @IBOutlet weak var imgPoint1: UIImageView!
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var lblPreviousPrice: UILabel!
    @IBOutlet weak var lblDistanceFromProvider: UILabel!
    @IBOutlet weak var lblFoodProviderName: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var discountLine: UIView!
    @IBOutlet weak var lblClosed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
}
    //MARK:- Other Helper Methods
    func configure(foodDetail: ServiceModel){
        
        if foodDetail.allSold == true {
            imgPoints2.isHidden = true
            imgPoint1.isHidden = true
            let tokens  = foodDetail.tokens
            lblDiscountedPrice.isHidden = true
            lblPreviousPrice.isHidden = true
            discountLine.isHidden = true
            self.lblClosed.isHidden = false
        }
        else {
            self.lblClosed.isHidden = true
            if GlobalData.shared.me?.profile == nil {
                imgPoints2.isHidden = true
                imgPoint1.isHidden = true
                let normalPrice = foodDetail.normalPrice!
                let price = foodDetail.price!
                lblPreviousPrice.text = "$\(String(format: "%.2f", normalPrice))"
                lblDiscountedPrice.text = "$\(String(format: "%.2f", price))"
            }
            else {
                print("detailUser", GlobalData.shared.me?.profile.subscriber)
                
                if (GlobalData.shared.me?.profile.subscriber)!{
                    imgPoints2.isHidden = false
                    imgPoint1.isHidden = true
                    let tokens  = foodDetail.tokens
                    lblDiscountedPrice.text = tokens
                    lblPreviousPrice.isHidden = true
                    lblDiscountedPrice.isHidden = false
                    discountLine.isHidden = true
                }else{
                    imgPoints2.isHidden = true
                    imgPoint1.isHidden = true
                    lblPreviousPrice.isHidden = false
                    discountLine.isHidden = false
                    let normalPrice = foodDetail.normalPrice!
                    let price = foodDetail.price!
                    lblPreviousPrice.text = "$\(String(format: "%.2f", normalPrice))"
                    lblDiscountedPrice.text = "$\(String(format: "%.2f", price))"
                }
            }
        }
        
        imgFoodImage.image  = nil
        imgFoodImage.af_setImage(withURL: URL.init(string: foodDetail.image)!)
        lblFoodName.text = foodDetail.name!
        if foodDetail.supplierName != nil {
            lblFoodProviderName.text = foodDetail.supplierName!
        }
       // let distance = foodDetail.distance!
       // lblDistanceFromProvider.text = String(format: "%.2f", distance)
        
        if foodDetail.distance != nil && foodDetail.timeWalking != nil {
            let distance = foodDetail.distance!
            let time = foodDetail.timeWalking
            if time != nil{
                lblDistanceFromProvider.text = "\(String(format: "%.2f", distance)) mi, \(time!) min away"
            }else{
                lblDistanceFromProvider.text = "\(String(format: "%.2f", distance)) min away"
            }            
        }
        
    }
}
