//
//  GetFoodDetailVCViewController.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 07/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class GetFoodDetailVCViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var txtSearch: UITextField!
    
    // MARK:- Other Variables
     var foodTypeData = [String]()
    // MARK: ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Other Helper Methods
    func configure() {
        foodTypeData = ["Chicken","Beef","Pork","Vegan"]
    }

}
