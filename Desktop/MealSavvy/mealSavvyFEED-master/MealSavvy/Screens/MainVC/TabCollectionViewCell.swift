//
//  TabCollectionViewCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 06/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    
    // MARK:- IBOutlets
        @IBOutlet weak var underlineView: UIView!
        @IBOutlet weak var viewTab: UIView!
        @IBOutlet weak var tabCell: UILabel!
    
    //MARK- Other variables
    var rowOnefoodList = Array<Dictionary<String,String>>()
    
    //MARK:- Other Helper Methods
    func configure(tabData: [String],index: Int,selecedIndex: Int){
         tabCell.text = tabData[index]

          if selecedIndex == index{
            self.viewTab.backgroundColor = UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) )
            self.viewTab.layoutIfNeeded()
          }else{
            self.viewTab.backgroundColor = UIColor.white
            self.viewTab.layoutIfNeeded()
        }
    }
}
