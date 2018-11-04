//
//  PaymentViewController.swift
//  MealSavvy
//
//  Created by JinJin Lee on 2018/8/21.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentViewController: BaseViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCardNum: UITextField!
    @IBOutlet weak var txtExp: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var promoCodeValidateImageView: UIImageView!
    @IBOutlet weak var benefitsTableView: UITableView!
    @IBOutlet weak var viewBenefits: UIView!
    @IBOutlet weak var btnSubscribeNow: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    
    let expiryDatePicker = MonthYearPickerView()
    
    public struct PLAN_ID {
        let Premium = 0;
        let Basic = 1;
        let Starter = 2;
    }
    
    @IBOutlet weak var heightBenefitConstraint: NSLayoutConstraint!
    
    var isFromSignup = false
    var isBasic = true
    var planType = 1
    var starterBenefits = ["200 Tokens per day", "1200 Tokens per month", "20+ Berkeley Restaurants"]
    var basicBenefits = ["200 Tokens per day", "3000 Tokens per month", "20+ Berkeley Restaurants"]
    var premiumBenefits = ["200 Tokens per day", "4500 Tokens per month", "Exclusive Restaurants", "Combo Items", "20+ Berkeley Restaurants"]


    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubscribeNow.makeRoundCorner(5)
        txtCVV.makeRoundCorner(5)
        txtZipCode.makeRoundCorner(5)
        txtCardNum.makeRoundCorner(5)
        txtName.makeRoundCorner(5)
        txtExp.makeRoundCorner(5)
        
        txtCVV.makeBorder(1, color: UIColor.gray)
        txtZipCode.makeBorder(1, color: UIColor.gray)
        txtExp.makeBorder(1, color: UIColor.gray)
        txtCardNum.makeBorder(1, color: UIColor.gray)
        txtName.makeBorder(1, color: UIColor.gray)
        
        viewBenefits.makeBorder(1, color: UIColor(red: 0/255.0, green: 166.0/255.0, blue: 82.0/255.0, alpha: 1.0))
        viewBenefits.makeRoundCorner(5)
        
        txtCVV.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtZipCode.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtExp.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtZipCode.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtCardNum.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        txtExp.inputView = expiryDatePicker
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
            self.txtExp.text = string
        }
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.init(rgb: 0x3F7613, a: 1.0)]
        
        let attrs3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.black]

        
        let attributedString1 = NSMutableAttributedString(string:"$375, ", attributes:attrs1)
        
        var attributedString2:NSMutableAttributedString!
        
        let attributedString3 = NSMutableAttributedString(string:" per month for an entire month of the best restaurant food.", attributes:attrs3)
        

        // Do any additional setup after loading the view.
        if  planType == PLAN_ID.init().Basic {
//            lblPrice.text = "$199"
            attributedString2 = NSMutableAttributedString(string:"$199 ", attributes:attrs2)
            
            heightBenefitConstraint.constant = CGFloat(basicBenefits.count*20)
        }else if planType == PLAN_ID.init().Starter{
//            lblPrice.text = "$99"
            attributedString2 = NSMutableAttributedString(string:"$99 ", attributes:attrs2)

            heightBenefitConstraint.constant = CGFloat(starterBenefits.count*20)
        }else{
//            lblPrice.text = "$349"
            attributedString2 = NSMutableAttributedString(string:"$349 ", attributes:attrs2)
            heightBenefitConstraint.constant = CGFloat(premiumBenefits.count*20)
        }
        
        attributedString2.append(attributedString3)
        attributedString1.append(attributedString2)

        self.lblStatus.attributedText = attributedString1
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.goBack()
    }
    
    private func goBack() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event Handler
    @IBAction func onClickSubscribeNow (_ sender: Any) {
        
        var type = ""
        if  planType == PLAN_ID.init().Basic {
            type = "basic"
        }else if planType == PLAN_ID.init().Starter{
            type = "starter"
        }else{
            type = "premium"
        }
        
        SVProgressHUD.show(withStatus: "Wait ...")
        
        var userCard = CreditCardModel()
        let arrName = txtName.text!.components(separatedBy: " ")
        let firstName = arrName[0]
        var lastName = ""
        if arrName.count > 1 {
            lastName = arrName[1]
        }
        
        let pass =  RSAUtils.getRSAPassword()
        let salt = RSAUtils.getRSASalt()
        let iv = RSAUtils.getRSAIv()
        
        let cardExpiryEncryt = EncryptionHelper.encrypt(txtExp.text!, password: pass, salt: salt, iv64: iv)
        let cvc = EncryptionHelper.encrypt(txtCVV.text!, password: pass, salt: salt, iv64: iv)
        let encryptCardNum = EncryptionHelper.encrypt(txtCardNum.text!, password: pass, salt: salt, iv64: iv)

        userCard.number = encryptCardNum
        userCard.expiration = cardExpiryEncryt
        userCard.cvc = cvc
        userCard.lastName = lastName
        userCard.firstName = firstName
        userCard.postalCode = txtZipCode.text!
        userCard.isDefault = false
        userCard.paymentType = ""
        userCard.paymentProcessorType = "Authorize.net"

        SocketService.shared.doMealPlan(type: type, promocode: "", card: userCard) { (subscriber, error) in
            if let _ = error {
                SVProgressHUD.showError(withStatus: error)
            } else {
                SVProgressHUD.dismiss()
                
                GlobalData.shared.me?.profile.subscriber = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let instance = storyboard.instantiateViewController(withIdentifier: "tabNavigation") as! UINavigationController
                DELEGATE.window?.rootViewController = instance

//                self.getUserInfo()
            }
        }
    }
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(planType)
        if planType == PLAN_ID.init().Basic {
            return basicBenefits.count
        }else if planType == PLAN_ID.init().Starter{
            return starterBenefits.count
        }else {
            return premiumBenefits.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBenefits", for: indexPath)
        let lblTitle = cell.viewWithTag(100) as! UILabel
        if planType == PLAN_ID.init().Basic {
            lblTitle.text = basicBenefits[indexPath.row]
        }else if planType == PLAN_ID.init().Starter{
            lblTitle.text = starterBenefits[indexPath.row]
        } else {
            lblTitle.text = premiumBenefits[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
