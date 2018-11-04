//
//  AddToTrayView.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 08/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddToTrayView: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet weak var btnOutSideViewShowDetail: UIButton!
    @IBOutlet weak var imgAddToTrayImage: UIImageView!
    @IBOutlet weak var btnAddToTray: UIButton!
    @IBOutlet weak var viewShowDetail: UIView!
    @IBOutlet weak var viewOverAllView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblResturant: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDistanceTime: UILabel!
    
    //MARK:- Other Variables
    var instance: GetFoodDetailVC?
    var foodDetail : ServiceModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARk:- IBAction
    @IBAction func btnOutSideViewShowDetail(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func checkDifferentSuppliers(_ inCuisine : ServiceModel) -> Bool {
        var supplierName = ""
        for perSer:ServiceModel in (GlobalData.shared.me?.cart)! {
            print(perSer.supplierName)
            if perSer.supplierName != supplierName && supplierName != ""{
                return true
            }
            supplierName = perSer.supplierName
        }
        
        return false
    }
    
    @IBAction func tapAddToTray(_ sender: UIButton) {
        
        if GlobalData.shared.me?.cart == nil {
            GlobalData.shared.me?.cart = []
        }
        GlobalData.shared.me?.cart.append(foodDetail)
        
        if self.checkDifferentSuppliers(foodDetail) == true {
            SVProgressHUD.showError(withStatus: "You cannot add items from different restaurants in one order.")
            GlobalData.shared.me?.cart.removeLast()
        }
        else {

            let moveToMealTray = storyboard?.instantiateViewController(withIdentifier: "MealTrayVc") as! MealTrayVc
            
            self.dismiss(animated: true, completion: {
                self.instance?.navigationController?.pushViewController(moveToMealTray, animated: true)
            })
        }
    }
    
    // MARK:- other Helper Methods
    func configure() {

        imgAddToTrayImage.image  = nil
        imgAddToTrayImage.af_setImage(withURL: URL.init(string: (foodDetail?.image)!)!)
        
        lblName.text = foodDetail.name
        
        if foodDetail.supplierName != nil {
            lblResturant.text = foodDetail.supplierName
        }
        
        lblDescription.text = foodDetail.description
        
        if foodDetail.distance != nil && foodDetail.timeWalking != nil {
            let distance = foodDetail.distance!
            let time = foodDetail.timeWalking
            if time != nil{
                lblDistanceTime.text = "\(String(format: "%.2f", distance)) mi, \(time!) min away"
            }else{
                lblDistanceTime.text = "\(String(format: "%.2f", distance)) min away"
            }
        }
       
        viewShowDetail.makeRoundCorner(10)
        btnAddToTray.makeRoundCorner(20)
        btnAddToTray.addShadow(radius: 10)
        imgAddToTrayImage.makeBorder(1, color: UIColor.black)
        btnAddToTray.addShadow(radius: 2)
        viewShowDetail.addShadow(radius: 3)
    }

}
