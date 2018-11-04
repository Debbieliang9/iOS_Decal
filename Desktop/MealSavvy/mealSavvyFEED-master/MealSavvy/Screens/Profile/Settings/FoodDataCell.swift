//
//  FoodDataCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 07/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class FoodDataCell: UICollectionViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblFoodType: UILabel!
    @IBOutlet weak var viewUnderLine: UIView!
    
    //MARK:- Other Helper Methods
    func configure(foodTypeData: SubCuisine ,index: Int,selecedIndex: Int){
        lblFoodType.text = foodTypeData.name
        if selecedIndex == index {
            self.viewUnderLine.backgroundColor = UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) )
            self.viewUnderLine.layoutIfNeeded()
        }else{
            self.viewUnderLine.backgroundColor = UIColor.white
            self.viewUnderLine.layoutIfNeeded()
        }
        }
    }
