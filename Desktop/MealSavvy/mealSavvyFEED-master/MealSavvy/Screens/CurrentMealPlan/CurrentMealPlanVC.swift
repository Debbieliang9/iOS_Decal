//
//  CurrentMealPlanVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 13/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import CircleProgressBar
import QuartzCore
import SVProgressHUD

//@available(iOS 11.0, *)
//@available(iOS 11.0, *)
//@available(iOS 11.0, *)
class CurrentMealPlanVC: UIViewController {
    
    //MARK:- IBAction
    
    @IBOutlet weak var lblRemainingToken: UILabel!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var viewPlanDetails: UIView!
    @IBOutlet weak var viewCurrentMealPlan: UIView!
    @IBOutlet weak var circleProgressBar: CircleProgressBar!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMealTray: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popInnerView: UIView!
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var lblCurrentPlan: UILabel!
    
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var lblThird: UILabel!
    
    //MARK:- Other Variables
    var mealPlanData = Array<Dictionary<String,String>>()

    
    //MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView.isHidden = true
        mealPlanData = [["mealsADay": "200 Tokens per day", "mealsAMonth" : "1200 Tokens per Month", "noOfRestaurants" : "20+ Berkeley Restaurants", "combo" : "", "exclusive" : "","image": "Group 78","mealPlan" : "STARTER / $99"],
                        ["mealsADay": "200 Tokens per day", "mealsAMonth" : "3000 Tokens per Month", "noOfRestaurants" : "20+ Berkeley Restaurants", "combo" : "", "exclusive" : "","image": "Group 77","mealPlan" : "BASIC / $199"],
                        ["mealsADay": "200 Tokens per day", "mealsAMonth" : "4500 Tokens per Month", "noOfRestaurants" : "Exclusive Restaurants", "combo" : "Combo Items", "exclusive" : "20+ Berkeley Restaurants","image": "Group 79","mealPlan" : "PREMIUM / $349"]]
        self.lblLink.layer.borderColor = UIColor.init(rgb: 0x01A652, a: 1.0).cgColor
        
        let hidePopupGesture = UITapGestureRecognizer(target: self, action: #selector(self.hidePopup))
        let ignorePopupGesture = UITapGestureRecognizer(target: self, action: #selector(self.ignorePopup))
        
        self.popupView.addGestureRecognizer(hidePopupGesture)
        self.popInnerView.addGestureRecognizer(ignorePopupGesture)

        btnPause.isHidden = true
        
        btnPause.makeRoundCorner(5)
        viewPlanDetails.makeRoundCorner(5)
        viewCurrentMealPlan.addShadowWithRadius(radius: 2, cornerRadius: 5)
        if #available(iOS 11.0, *) {
            circleProgressBar.accessibilityIgnoresInvertColors = true
        } else {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserInfo()

        if GlobalData.shared.me?.cart != nil {
            lblMealTray.text = String((GlobalData.shared.me?.cart.count)!)
        }
        
    }
    
    private func getUserInfo () {
        
        var hId = ""
        if GlobalData.shared.me?.hid == nil {
            hId = (GlobalData.shared.me?.profile.hid)!
        }
        else {
            hId = (GlobalData.shared.me?.hid)!
        }
        
        SocketService.shared.getUserInfo(hId,
                                         token: (GlobalData.shared.me?.token)!,
                                         deviceToken: GlobalData.shared.deviceToken) { (user, error) in
                                            if let _ = error {
                                                SVProgressHUD.showError(withStatus: error)
                                            } else {
                                                GlobalData.shared.me?.update(user!)
                                                self.configure()
                                            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCopy(_ sender: Any) {
        UIPasteboard.general.string = self.lblLink.text
        self.popupView.isHidden = true
    }
    
    @IBAction func onReferralTap(_ sender: Any) {
        
        var str:String = "https://mealsavvyapp.com/" + (GlobalData.shared.me?.profile.hid)!
        self.lblLink.text = str
        self.popupView.isHidden = false
    }
    
    @objc func hidePopup() {
        self.popupView.isHidden = true
    }
    
    @objc func ignorePopup() {
    }

    //MARK:- Other Methods
   
    func configure() {
        print(GlobalData.shared.me?.profile.subscriberInfo.price)
        
        if GlobalData.shared.me?.profile.subscriberInfo.remainingToken != nil {
            lblRemainingToken.text = "\((GlobalData.shared.me?.profile.subscriberInfo.remainingToken)!)"
        }
        
        if GlobalData.shared.me?.profile.subscriberInfo.type != nil &&  GlobalData.shared.me?.profile.subscriberInfo.price != nil {
            let planType:String = GlobalData.shared.me?.profile.subscriberInfo.type as! String
            let planPrice:String = GlobalData.shared.me?.profile.subscriberInfo.price as! String
            
            
            var planIndex = 0
            if planType == "starter" {
                planIndex = 0
            }
            else if planType == "basic" {
                planIndex = 1
            }
            else if planType == "premium" {
                planIndex = 2
            }
            lblFirst.text = mealPlanData[planIndex]["mealsADay"]
            lblSecond.text = mealPlanData[planIndex]["mealsAMonth"]
            lblThird.text = mealPlanData[planIndex]["noOfRestaurants"]
            
            lblCurrentPlan.text = "\(planType.uppercased()) / $\(planPrice)"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        
        if GlobalData.shared.me?.profile.subscriberInfo.start != nil && GlobalData.shared.me?.profile.subscriberInfo.finish != nil {
            lblDate.text = formatter.string(from: (GlobalData.shared.me?.profile.subscriberInfo.start)!) + " - " + formatter.string(from: (GlobalData.shared.me?.profile.subscriberInfo.finish)!)
        }
        
        var referralCount:Int = 0
        if GlobalData.shared.me?.profile.subscriberInfo.referralCount != nil {
            referralCount = (GlobalData.shared.me?.profile.subscriberInfo.referralCount)!
        }
        lblStatus.text = String(3 - referralCount) + " people away from 500 Tokens."
        
        circleProgressBar.setProgress(CGFloat(referralCount) / 3, animated: true, duration: 1)
            circleProgressBar.setHintTextGenerationBlock({ (progress) -> String? in
                let str = String(referralCount) + "/3"
                return String.init(format: str, [progress * 3])
            })
            circleProgressBar.progressBarWidth = 5
            circleProgressBar.hintViewSpacing = 10
            circleProgressBar.hintTextFont = UIFont.systemFont(ofSize: 23)
    }
}
