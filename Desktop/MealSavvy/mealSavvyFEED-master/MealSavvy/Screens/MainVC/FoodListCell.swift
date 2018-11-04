//
//  FoodListCell.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 06/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import Kingfisher

class FoodListCell: UICollectionViewCell {
    
    @IBOutlet weak var imgFoodPicture: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgFoodPicture.makeRoundCorner(15)
    }
    
    var cuisine: CuisineModel! {
        didSet {
            lblFoodName.text = cuisine.name
            
            imgFoodPicture.kf.setImage(with: URL(string: (cuisine.image)!),
                                       placeholder: nil,
                                       options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
            })
        }
    }
    
    var restaurant: RestaurantModel! {
        didSet {
            lblFoodName.text = restaurant.name
            
            imgFoodPicture.kf.setImage(with: URL(string: (restaurant.image)!),
                                       placeholder: nil,
                                       options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
            })
        }
    }
    
    var favorite: RestaurantModel! {
        didSet {
            lblFoodName.text = favorite.name
            
            imgFoodPicture.kf.setImage(with: URL(string: (favorite.image)!),
                                       placeholder: nil,
                                       options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
            })
        }
    }
    
}
