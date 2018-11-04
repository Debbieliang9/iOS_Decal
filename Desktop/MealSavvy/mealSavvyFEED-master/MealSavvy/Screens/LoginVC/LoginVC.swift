//
//  LoginVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 08/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SVProgressHUD

class LoginVC: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
         configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //MARK:- UIButton Action
    @IBAction func tapOnForgot(_ sender: UIButton) {
        let instance = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        instance.type  = .ForgotPassword
        self.navigationController?.pushViewController(instance, animated: true)
    }
    
    @IBAction func tapOnForgotHuman(_ sender: UIButton) {
        let instance = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        instance.type  = .ForgotHumid
        self.navigationController?.pushViewController(instance, animated: true)
    }
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        let moveToCreateAccountVc = storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        self.navigationController?.pushViewController(moveToCreateAccountVc, animated: true)
    }
    
    @IBAction func tabLoginWithFacebook(_ sender: UIButton) {
        facebookIntegration()
    }
    
    @IBAction func tabLogin(_ sender: UIButton) {
        if validate() {
            view.endEditing(true)
            SVProgressHUD.show(withStatus: "Login ...")
            SocketService.shared.signIn(txtPhone.text!,
                                        password: EncryptionHelper.encrypt(txtPassword.text!),
                                        isEncrypted: true,
                                        deviceToken: GlobalData.shared.deviceToken) { (user, error) in
                                            if let _ = error {
                                                SVProgressHUD.showError(withStatus: error)
                                            } else {
                                                SVProgressHUD.dismiss()
                                                GlobalData.shared.me = user
                                                let instance = self.storyboard?.instantiateViewController(withIdentifier: "tabNavigation") as! UINavigationController
                                                APP_DELEDATE.window?.rootViewController = instance
                                               // self.navigationController?.dismiss(animated: true, completion: nil)
                            }
            }
        }
    }
    //MARK:- Other Helper Methods
    func configure() {
        viewPhoneNumber.addShadowWithRadius(radius: 2, cornerRadius: 20)
        viewPassword.addShadowWithRadius(radius: 2, cornerRadius: 20)
        btnLogin.makeRoundCorner(20)
        btnLoginWithFacebook.makeRoundCorner(20)
        txtPhone.delegate = self
        txtPassword.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func facebookIntegration() {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: {
            (result,error) -> Void in
            if error == nil {
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                if (fbLoginResult.isCancelled) {
                    
                } else {
                    if (fbLoginResult.grantedPermissions.contains("email")) {
                        print("accessToken: ", fbLoginResult.token.tokenString)
                        let fbToken:String = fbLoginResult.token.tokenString
                        self.returnUserData(fbToken)
                    }
                }
            }
        })
    }
    
    func returnUserData(_ fbToken:String) {
        if ((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,email"]).start(completionHandler: {
                (connection,result,error) -> Void in
                if error == nil {
                    guard let data = result as? [String:Any] else { return}
                    print(data)
                    let fbid:String = data["id"] as! String
                    let userName = data["name"]
                    let firstName = data["first-name"]
                    let mailId = data["email"]
                    
                    SocketService.shared.signIn(fbToken,
                            deviceToken: GlobalData.shared.deviceToken) { (user, error) in
                                if let _ = error {
                                    SVProgressHUD.showError(withStatus: error)
                                } else {
                                    SVProgressHUD.dismiss()
                                    GlobalData.shared.me = user
                                    let instance = self.storyboard?.instantiateViewController(withIdentifier: "tabNavigation") as! UINavigationController
                                    APP_DELEDATE.window?.rootViewController = instance
                                }
                    }
                    
                }
            })
        }
    }
    func validate() ->Bool {
        if txtPhone.text == "" {
            self.showOkAlert("Please Enter Phone Number")
            return false
        } else if txtPassword.text == "" {
            self.showOkAlert("Please Enter Password")
            return false
        } else if txtPassword.text!.count < 8 {
            self.showOkAlert("Length of Password Should Be between 8 to 15")
            return false
        } else if txtPassword.text!.count > 15 {
            self.showOkAlert("Length of Password Should Be between 8 to 15")
            return false
        }
        return true
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone {
            return MBUtils.isShouldChangeHumanId(textField, range: range, replacementString: string)
        } else if textField == txtPassword {
            let totalPasswordCount = (txtPassword.text?.count)! + string.count
            return totalPasswordCount <= 15
        } else {
            return true
        }
    }
}
