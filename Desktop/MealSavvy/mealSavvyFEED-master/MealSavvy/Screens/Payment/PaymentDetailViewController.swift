//
//  PaymentDetailViewController.swift
//  MealSavvy
//
//  Created by iOS Developer on 10/8/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var imageCardType: UIImageView!
    @IBOutlet weak var txtCardNum: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtCVC: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    @IBOutlet weak var check3: UIImageView!
    @IBOutlet weak var checkBox: UIButton!
    
    var cardType : Int!
    var format : DateFormatter!
    var arrayMonth : NSMutableArray!
    var arrayYear : NSMutableArray!
    var cardTypeString: String!
    
    let mastercard = 1
    let visa = 2
    let amex = 3
    let diners_club = 4
    let discover = 5
    let enRoute = 6
    let jcb = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        format = DateFormatter()
        format.dateStyle = .short
        format.dateFormat = "MM-yyyy"
        self.initMonthAndYearArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func dismissKeyboard() {
    }
    
    private func initMonthAndYearArray() {
        arrayMonth = NSMutableArray()
        arrayYear = NSMutableArray()
        
        var currentYear: Int = Calendar.current.component(.year, from: Date())
        for i in 0..<12 {
            arrayMonth.add("\(i + 1)")
            arrayYear.add(String(format: "%zd", i + currentYear))
        }
    }
    
    private func isValidCardNumber() -> Bool {
        
        var stringCard:String = self.txtCardNum.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        switch cardType {
            case mastercard:
                if stringCard.count != 16 {
                    return false
                }
            case visa:
                if stringCard.count != 16 {
                    return false
                }
            case amex:
                if stringCard.count != 15 {
                    return false
                }
            case diners_club:
                if stringCard.count != 14 {
                    return false
                }
            case discover:
                if stringCard.count != 16 {
                    return false
                }
            case jcb:
                if stringCard.count != 16 {
                    return false
                }
            default:
                break
        }
        return true
    }
    
    private func isValidateExpiration(_ card:CreditCardModel) -> Bool {
        
        let expDate:String = "\(txtMonth.text!)-\(txtYear.text!)"
        print(expDate)
    
        var validateDOB: Date? = format.date(from: expDate)
        if validateDOB != nil {
            card.expiration = "\(txtMonth.text)-\(txtYear.text)"
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.dismissKeyboard()
        if (self.txtCardNum.text?.count)! < 1 {
            self.showOkAlert("Please enter card number")
            return
        }
        if self.isValidCardNumber() == false {
            self.showOkAlert("Please enter valid card number")
            return
        }
        if (txtMonth.text?.count)! < 1 {
            self.showOkAlert("Please enter Expiration Month")
            return
        }
        if (txtYear.text?.count)! < 1 {
            self.showOkAlert("Please enter Expiration Year")
            return
        }
        
        var card:CreditCardModel = CreditCardModel()
        card.expiration = self.txtMonth.text
        
        if self.isValidateExpiration(card) == false {
            self.showOkAlert("Please enter valid Expiration Date")
            return
        }
        
        if txtCVC.text == nil || txtCVC.text == "" {
            self.showOkAlert("Please enter CVC")
            return
        }
        if txtPostalCode.text == nil || txtPostalCode.text == "" {
            self.showOkAlert("Please enter Postal Code")
            return
        }
        card.postalCode = txtPostalCode.text
        var password = RSAUtils.getRSAPassword()
        var salt = RSAUtils.getRSASalt()
        var IV = RSAUtils.getRSAIv()
        var dateFormat = DateFormatter()
        
        var encriptedCardNumber = EncryptionHelper.encrypt(txtCardNum.text!.replacingOccurrences(of: " ", with: ""), password: password, salt: salt, iv64: IV)
        
        card.number = encriptedCardNumber
        card.cvc = EncryptionHelper.encrypt(txtCVC.text, password: password, salt: salt, iv64: IV)
        card.isDefault = self.checkBox.isSelected;
        card.cardType = cardTypeString
        
        if check1.isHidden == false {
            card.paymentType = PAYMENT_TYPE_PERSONAL
        }
        else if check2.isHidden == false {
            card.paymentType = PAYMENT_TYPE_BUSINESS
        }
        else {
            card.paymentType = PAYMENT_TYPE_ORTHER
        }
        card.paymentProcessorType = PaymentProcessorTypeNet
        self.updatePayment(card)
    }
    
    private func updatePayment(_ card:CreditCardModel) {
        
        if GlobalData.shared.me?.profile.creditCards == nil {
            GlobalData.shared.me?.profile.creditCards = []
        }
        GlobalData.shared.me?.profile.creditCards.append(card)

        SVProgressHUD.show(withStatus: "Please wait ...")
        
        var hId = ""
        if GlobalData.shared.me?.hid == nil {
            hId = (GlobalData.shared.me?.profile.hid)!
        }
        else {
            hId = (GlobalData.shared.me?.hid)!
        }

        SocketService.shared.updateUserInfo(hId, token: (GlobalData.shared.me?.token)!,
                                            deviceToken: GlobalData.shared.deviceToken) { (user, error) in
                if let _ = error {
                    SVProgressHUD.showError(withStatus: error)
                } else {
                    self.showOkAlert("Card Added Successfully")
                    GlobalData.shared.me?.update(user!)
        }}

    }
    
    @IBAction func onBack(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTouchButtonCardType(_ sender: UIButton) {
        self.check1.isHidden = true
        self.check2.isHidden = true
        self.check3.isHidden = true
        
        switch sender.tag{
        case 0://personal
            self.check1.isHidden = false
            break
        case 1://Business
            self.check2.isHidden = false
            break
        case 2://Other
            self.check3.isHidden = false
            break
        default:
            break
        }
    }
    
    private func startWith(_ character:String, text: String) -> Bool {
        
        var temp:String = String(text.prefix(character.count))
        if temp == character {
            return true
        }
        else {
            return false
        }
    }
    
    private func determineCardType(_ cardNumber:String) ->Int {
        
        if cardNumber.count < 4 {
            return -1
        }
        // NSInteger len = cardNumber.length;
        var cType: Int = -1
        
        // mastercard
        if startWith("5", text: cardNumber) {
            
            cType = 1
        } else // visa
            if startWith("4", text: cardNumber) {
                cType = 2
            } else // amex
                if startWith("34", text: cardNumber) || startWith("37", text: cardNumber) {
                    
                    cType = 3
                } else // diners
                    if startWith("36", text: cardNumber) || startWith("38", text: cardNumber) || startWith("300", text: cardNumber) || startWith("301", text: cardNumber) || startWith("302", text: cardNumber) || startWith("303", text: cardNumber) || startWith("304", text: cardNumber) || startWith("305", text: cardNumber) {
                        
                        cType = 4
                    } else // discover
                        if startWith("6011", text: cardNumber) {
                            
                            cType = 5
                        } else // enRoute
                            if startWith("2014", text: cardNumber) || startWith("2149", text: cardNumber) {
                                
                                // any digit check
                                return 6
                            } else // jcb
                                if startWith("3", text: cardNumber) {
                                    
                                    cType = 7
                                } else // jcb
                                    if startWith("2131", text: cardNumber) || startWith("1800", text: cardNumber) {
                                        
                                        
                                        cType = 7
                                    } else {
                                        return -1
        }
        
        
        return cType
    }
    
    private func getCardIcon(_ type:Int) -> UIImage {
        switch type {
        case mastercard:
            cardTypeString = MASTERCARD
            return UIImage(named: "mastercard")!
        case visa:
            cardTypeString = VISA
            return UIImage(named: "visa")!
        case amex:
            cardTypeString = AMERICAN_EXPRESS
            return UIImage(named: "american-express")!
        case diners_club:
            cardTypeString = DINERS_CLUB
            return UIImage(named: "diners-club")!
        case discover:
            cardTypeString = DISCOVER
            return UIImage(named: "discover")!
        case jcb:
            cardTypeString = JCB
            return UIImage(named: "jcb")!
        default:
            cardTypeString = VISA
        }
        return UIImage()
    }
    
    @IBAction func didTouchUseAsDefaultButton(_ sender: Any) {
        self.checkBox.isSelected = !self.checkBox.isSelected
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PaymentDetailViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 0:
        
            var text:String = textField.text!
            var characterSet = CharacterSet(charactersIn: "0123456789")
            var stringTxt:String = string
            stringTxt = stringTxt.replacingOccurrences(of: " ", with: "")
//            if Int(stringTxt.rangeOfCharacter(from: characterSet.inverted).location) != NSNotFound {
//                return false
//            }
//
//            text = text.replacingCharacters(in: range, with: stringTxt)
            text = text.replacingOccurrences(of: " ", with: "")
            
            var newString = ""
            var i: Int = 0
            
            while text.count > 0 {
                var sublength: Int = 4
                if cardType == amex {
                    if i == 1 {
                        sublength = 6
                    }
                    if i == 2 {
                        sublength = 5
                    }
                }
                
                var subString = (text as? NSString)?.substring(to: min(text.count, sublength))
                newString = newString + (subString ?? "")
                if (subString?.count ?? 0) == sublength {
                    newString = newString + (" ")
                }
                text = ((text as? NSString)?.substring(from: min(text.count, sublength)))!
                i += 1
            }
            
            cardType = determineCardType(newString)
            newString = newString.trimmingCharacters(in: characterSet.inverted)
            if newString.count < 5 || stringTxt.count > 1 {
                imageCardType.image = getCardIcon(cardType)
            }
            switch cardType {
            case diners_club:
                if newString.count >= 18 {
                    return false
                }
            case amex:
                if newString.count >= 18 {
                    return false
                }
            default:
                if newString.count >= 20 {
                    return false
                }
            }
            textField.text = newString
            break
        case 3:
            var newLength: Int = textField.text!.count + string.count - range.length
            var cs = CharacterSet(charactersIn: "1234567890").inverted
            var filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered) && (newLength <= 3)
            break
        case 4:
            var newLength: Int = textField.text!.count + string.count - range.length
            var cs = CharacterSet(charactersIn: "1234567890").inverted
            var filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered) && (newLength <= 5)
            break
        default:
            break
        }
        return true
    }
}
