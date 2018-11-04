//
//  MealPlanTableViewCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 10/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

protocol MealPlanTableViewCellDelegate {
    func cell(_ tableViewCell: MealPlanTableViewCell, didSelectPlan data: [String:String])
}

class MealPlanTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var viewPlan: UIView!
    @IBOutlet weak var viewOverAll: UIView!
    @IBOutlet weak var imgPlanImage: UIImageView!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblExclusiveRestaurants: UILabel!
    @IBOutlet weak var lblComboItems: UILabel!
    @IBOutlet weak var lblNumberRestaurants: UILabel!
    @IBOutlet weak var lblMealPerMonth: UILabel!
    @IBOutlet weak var lblMealsPerDay: UILabel!
    
    var data: [String:String]! {
        didSet {
            imgPlanImage.image = UIImage.init(named: data["image"]!)
            lblPlanName.text = data["mealPlan"]
            lblExclusiveRestaurants.text = data["exclusive"]
            lblComboItems.text = data["combo"]
            lblNumberRestaurants.text = data["noOfRestaurants"]
            lblMealsPerDay.text = data["mealsADay"]
            lblMealPerMonth.text = data["mealsAMonth"]
        }
    }
    
    var delegate: MealPlanTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOverAll.addShadowWithRadius(radius: 2, cornerRadius: 5)
        btnSelect.makeRoundCorner(5)
        viewPlan.makeRoundCorner(5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Event Handler
    @IBAction func onClickSelect(_ sender: Any) {
        guard let _ = delegate else {
            return
        }
        delegate?.cell(self, didSelectPlan: data)
    }
}
