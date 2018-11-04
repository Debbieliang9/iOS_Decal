//
//  ChangePasswordVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 13/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var viewStack: UIView!
    
    //MARK:- View controller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapChangePassword(_ sender: UIButton) {
        if validation() {
        }
    }
    
    //MARK:- Other Helper Methods
    func configure() {
        viewStack.addShadowWithRadius(radius: 1, cornerRadius: 5)
        btnChangePassword.makeRoundCorner(20)
    }
    func validation() -> Bool {
        if txtOldPassword.text == "" {
            self.showOkAlert("Please Enter Current Password")
            return false
        } else if txtNewPassword.text == "" {
            self.showOkAlert("Please Enter New Password")
            return false
        } else if txtConfirmPassword.text == "" {
            self.showOkAlert("Please Enter Confirm Password")
            return false
        } else if txtNewPassword.text != txtConfirmPassword.text {
            self.showOkAlert("New password and Confirm Password Doesnot Match")
            return false
        }
        return true
    }
}
