//
//  PlanNavigation.swift
//  MealSavvy
//
//  Created by Sumit  Appsinvo on 24/09/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class PlanNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(GlobalData.shared.me?.profile)
        if GlobalData.shared.me?.profile == nil {
            let planVc = self.storyboard?.instantiateViewController(withIdentifier: "MealPlanVc") as! MealPlanVc
            self.viewControllers = [planVc]
            return
        }
        
        if (GlobalData.shared.me?.profile.subscriber)!{
            let planVc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentMealPlanVC") as! CurrentMealPlanVC
            self.viewControllers = [planVc]
        }else{            
            let planVc = self.storyboard?.instantiateViewController(withIdentifier: "MealPlanVc") as! MealPlanVc
            self.viewControllers = [planVc]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
