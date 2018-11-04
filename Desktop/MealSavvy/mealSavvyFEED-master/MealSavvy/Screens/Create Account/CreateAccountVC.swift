//
//  CreateAccountVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 08/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateAccountVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewStack: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    //MARK:- ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
          configure()
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    //MARK:- IBAction
    @IBAction func tapNext(_ sender: UIButton) {
        
        if validateEmptyFields() {
            let moveToSetUpProfile = self.storyboard?.instantiateViewController(withIdentifier: "SetUpProfile") as! SetUpProfile
            moveToSetUpProfile.email = self.txtEmail.text!
            moveToSetUpProfile.phone = self.txtPhone.text!
            moveToSetUpProfile.pasword =  self.txtPassword.text!
            self.navigationController?.pushViewController(moveToSetUpProfile, animated: true)
            
//            view.endEditing(true)
//            SVProgressHUD.show(withStatus: "Login ...")
//            SocketService.shared.checkEmailPhone(txtEmail.text!, phone: txtPhone.text!, completion: { (user, error) in
//                if let _ = error {
//                    SVProgressHUD.showError(withStatus: error)
//                } else {
//                    SVProgressHUD.dismiss()
//                   // GlobalData.shared.me = user
//                    //self.navigationController?.dismiss(animated: true, completion: nil)
//
//                }
//            })
        }
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Other Helper Methods
    func configure() {
        viewStack.addShadowWithRadius(radius: 1, cornerRadius: 5)
        btnNext.makeRoundCorner(20)
        txtEmail.delegate = self
        txtPhone.delegate = self
        txtPassword.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    func validateEmptyFields() -> Bool {
        if txtEmail.text == "" {
            self.showOkAlert("Please Enter Email ID.")
            return false
        }
        if !SGHelper.isValidEmail(txtEmail.text!){
            self.showOkAlert("Please Enter a Valid Email.")
            return false
        }else if txtPhone.text == "" {
            self.showOkAlert("Please Enter Your Phone Number.")
            return false
        } else if txtPassword.text == "" {
            self.showOkAlert("Please Enter Your Password.")
            return false
        } else if txtPhone.text!.count < 8 {
            self.showOkAlert("Length of Phone should be between 8 to 12.")
            return false
        } else if txtPhone.text!.count > 12 {
            self.showOkAlert("Length of Phone should be between 8 to 12.")
            return false
        } else if txtPassword.text!.count > 15 {
            self.showOkAlert("Length of Password Should Be between 8 to 15")
            return false
        } else if txtPassword.text!.count < 8 {
            self.showOkAlert("Length of Password Should Be between 8 to 15")
            return false
        }
        return true
    }

}
extension CreateAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone {
            var totalPhoneCount = txtPhone.text!.count + string.count
            return totalPhoneCount <= 12
        } else if textField == txtPassword {
            var totalPasswordCount = txtPassword.text!.count + string.count
            return totalPasswordCount <= 15
        }
        return true
    }
}
