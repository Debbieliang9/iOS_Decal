//
//  ForgotPassVC.swift
//  MealSavvy
//
//  Created by Sumit  Appsinvo on 19/09/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPassVC: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblHumanID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    // MARK:- Injectable
    enum ScreenType : Int{
        case ForgotPassword
        case ForgotHumid
    }
    var type : ScreenType = ScreenType.init(rawValue: 0)!
    
    // MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        lblHumanID.text = ""
        lblName.text = ""
        super.viewDidLoad()
        switch type {
        case .ForgotHumid:
            lblTitle.text = "FORGOT HUMAN ID"
            txtEmail.placeholder = "Email"
            txtEmail.keyboardType = .emailAddress
            break
        case .ForgotPassword:
            lblTitle.text = "FORGOT PASSWORD"
            txtEmail.placeholder = "Human ID"
            txtEmail.keyboardType = .numbersAndPunctuation
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK:- UIButton Action
    @IBAction func tapOncelCan(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnLockup(_ sender: UIButton) {
        switch type {
        case .ForgotPassword:
            if txtEmail.text == ""{
                self.showOkAlert("Please enter Human ID.")
                return
            }else{
                forgotPassword()
            }
            break
        case .ForgotHumid:
            if txtEmail.text == ""{
                self.showOkAlert("Please enter Email.")
                return
            }else if !SGHelper.isValidEmail(txtEmail.text!){
                self.showOkAlert("Please enter a valid Email.")
                return
            }else{
                forgotHumId()
            }
            break
        }
    }
    
    //MARK:- Other Helper Methods
    func forgotHumId(){
        SVProgressHUD.show(withStatus: "Wait ...")
        SocketService.shared.forgotHumanID(txtEmail.text!) { (profile, error) in
            if let _ = error {
                SVProgressHUD.showError(withStatus: error)
            } else {
                SVProgressHUD.dismiss()
                
            }
            if error == nil{
                print(profile)
                self.lblHumanID.text = "Hid : \(profile?["hid"] as! String)"
                self.lblName.text =    "Name : \(profile?["name"] as! String)"
            }
        }
    }
    
    func forgotPassword(){
        SVProgressHUD.show(withStatus: "Wait ...")
        SocketService.shared.forgotPassword(txtEmail.text!) { (isSuccess, error) in
            if let _ = error {
                SVProgressHUD.showError(withStatus: error)
            } else {
                SVProgressHUD.dismiss()
                
            }
            if error == nil && isSuccess == true{
                self.showOkAlertWithHandler("Please check your email", handler: {
                    self.tapOncelCan(UIButton())
                })
            }
        }
    }
    
    
}
