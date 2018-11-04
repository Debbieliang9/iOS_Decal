//
//  MealPlanVc.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 10/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class MealPlanVc: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var mealTrayLabel: UILabel!
    @IBOutlet weak var remainingTokenLabel: UILabel!
    @IBOutlet weak var viewNoActivePlan: UIView!
    @IBOutlet weak var tableViewData: UITableView!
    //MARK:- Other Variables
    var mealPlanData = Array<Dictionary<String,String>>()
    var tokenPlanData = Array<Dictionary<String,String>>()
    
    public struct PLAN_ID {
        let Premium = 0;
        let Basic = 1;
        let Starter = 2;
    }
    
    //MARK:- View controller LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GlobalData.shared.me?.cart != nil {
            mealTrayLabel.text = String((GlobalData.shared.me?.cart.count)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Other Helper Methods
    func configure() {
        mealPlanData = [["mealsADay": "200 Tokens per day", "mealsAMonth" : "1200 Tokens per month", "noOfRestaurants" : "20+ Berkeley Restaurants", "combo" : "", "exclusive" : "","image": "Group 78","mealPlan" : "STARTER / $99"],
        ["mealsADay": "200 Tokens per day", "mealsAMonth" : "3000 Tokens per month", "noOfRestaurants" : "20+ Berkeley Restaurants", "combo" : "", "exclusive" : "","image": "Group 77","mealPlan" : "BASIC / $199"],
        ["mealsADay": "200 Tokens per day", "mealsAMonth" : "4500 Tokens per month", "noOfRestaurants" : "Exclusive Restaurants", "combo" : "Combo Items", "exclusive" : "20+ Berkeley Restaurants","image": "Group 79","mealPlan" : "PREMIUM / $349"]]
        
        tokenPlanData = [["mealsADay": "200 Tokens per day", "mealsAMonth" : "1200 Tokens per Month", "noOfRestaurants" : "20+ Berkeley Restaurants", "combo" : "", "exclusive" : "","image": "Group 78","mealPlan" : "STARTER / $99"],
                         ["mealsADay": "200 Tokens per day", "mealsAMonth" : "3000 Tokens per Month", "noOfRestaurants" : "20+ Berkeley Restaurants", "combo" : "", "exclusive" : "","image": "Group 77","mealPlan" : "BASIC / $199"],
                         ["mealsADay": "200 Tokens per day", "mealsAMonth" : "4500 Tokens per Month", "noOfRestaurants" : "Exclusive Restaurants", "combo" : "Combo Items", "exclusive" : "20+ Berkeley Restaurants","image": "Group 79","mealPlan" : "PREMIUM / $349"]]
        
        tableViewData.register(UINib(nibName: "MealPlanTableViewCell", bundle: nil), forCellReuseIdentifier: "MealPlanTableViewCell")
        viewNoActivePlan.addShadowWithRadius(radius: 2, cornerRadius: 5)
        setUserInfo()
    }
    
    private func setUserInfo () {
        if GlobalData.shared.me?.profile == nil {
            return
        }        
        
        if GlobalData.shared.me?.profile.subscriberInfo.remainingToken == nil {
            return
        }        
        // remaining tokens
        remainingTokenLabel.text = "\((GlobalData.shared.me?.profile.subscriberInfo.remainingToken)!)"
        
        // meal tray
        mealTrayLabel.text = "\((GlobalData.shared.me?.profile.subscriberInfo.remainingMeals)!)"
    }
    
    // MARK: - Event Handler
    @IBAction func onClickMealTray(_ sender: Any) {
        if GlobalData.shared.me?.cart == nil || GlobalData.shared.me?.cart.count == 0 {
            return
        }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MealTrayVc") else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension MealPlanVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealPlanData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "MealPlanTableViewCell") as! MealPlanTableViewCell
        if indexPath.row == 0 {
            returnCell.viewOverAll.backgroundColor = UIColor.getRGBColor(30, g: 183, b: 233)
            returnCell.lblPlanName.textColor = UIColor.getRGBColor(30, g: 183, b: 233)
            returnCell.btnSelect.setTitleColor(UIColor.getRGBColor(30, g: 183, b: 233), for: UIControlState.normal)
        }
        else if indexPath.row == 1 {
            returnCell.viewOverAll.backgroundColor = UIColor.getRGBColor(3 , g: 154, b: 71)
            returnCell.lblPlanName.textColor = UIColor.getRGBColor(3 , g: 154, b: 71)
            returnCell.btnSelect.setTitleColor(UIColor.getRGBColor(3 , g: 154, b: 71), for: UIControlState.normal)
        } else if indexPath.row == 2 {
            returnCell.viewOverAll.backgroundColor = UIColor.getRGBColor(255 , g: 180, b: 43)
            returnCell.lblPlanName.textColor = UIColor.getRGBColor(255 , g: 180, b: 43)
            returnCell.btnSelect.setTitleColor(UIColor.getRGBColor(255 , g: 180, b: 43), for: UIControlState.normal)
        }
        
        print(GlobalData.shared.me?.profile)
        
        if GlobalData.shared.me?.profile.subscriber == true {
            returnCell.data = tokenPlanData[indexPath.row]
        }
        else {
            returnCell.data = mealPlanData[indexPath.row]
        }
        
        returnCell.delegate = self
        return returnCell
    }
    
}

extension MealPlanVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 230
        }
        return 185
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goOnRestaurantsViewController(indexPath.row)
    }
    
    func goOnRestaurantsViewController(_ index:Int){
        let instance = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        
        if index == 0 {
            instance.planType = PLAN_ID.init().Starter
        }
        else if index == 1 {
            instance.planType = PLAN_ID.init().Basic
        }
        else {
            instance.planType = PLAN_ID.init().Premium
        }
        
        self.navigationController?.pushViewController(instance, animated: true)
    }
    
}


extension MealPlanVc: MealPlanTableViewCellDelegate {
    func cell(_ tableViewCell: MealPlanTableViewCell, didSelectPlan data: [String : String]) {
        let index = 0 //mealPlanData.index(of: data)!
        if index == 0 {
            
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as? RestaurantsViewController else {
                return
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

