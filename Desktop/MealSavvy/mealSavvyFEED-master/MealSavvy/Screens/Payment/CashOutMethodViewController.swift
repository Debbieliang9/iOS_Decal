//
//  CashOutMethodViewController.swift
//  MealSavvy
//
//  Created by iOS Developer on 10/9/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class CashOutMethodViewController: UIViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var labelStep1: UILabel!
    @IBOutlet weak var labelStep2: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonAddMethod: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var isDeposit : Bool!
    var isRequireDeposit:Bool!
    var amountToCashOut:CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PaymentCollectionViewCell.self, forCellWithReuseIdentifier: "PaymentCollectionViewCell")
        collectionView.register(CashOutMethodCollectionViewCell.self, forCellWithReuseIdentifier: "CashOutMethodCollectionViewCell")

        // Do any additional setup after loading the view.
        self.collectionView.clipsToBounds = true
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.layer.cornerRadius = 5.0
        self.collectionView.layer.borderColor = UIColor.init(rgb: 0xd0d0d0, a: 1.0).cgColor
        self.collectionView.layer.borderWidth = 1.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isDeposit {
            self.lblTitle.text = "Deposit"
            self.labelStep1.text = "Amount to deposit"
            self.labelStep2.text = "Method to deposit"
            self.buttonAddMethod.setTitle("Add deposit method", for: .normal)
        }
        else {
            self.lblTitle.text = "Cash Out"
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onNext(_ sender: Any) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchAddMethod(_ sender: Any) {
        if self.isDeposit {
            self.performSegue(withIdentifier: "show.detail", sender: nil)
        }
        else {
            
        }
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

extension CashOutMethodViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isDeposit {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCollectionViewCell", for: indexPath) as! PaymentCollectionViewCell
            var card:CreditCardModel = (GlobalData.shared.me?.profile.creditCards[indexPath.row])!
            
            if card.cardType == MASTERCARD {
                cell.cardIcon.image = UIImage(named:"mastercard")
            }
            else if card.cardType == AMERICAN_EXPRESS {
                cell.cardIcon.image = UIImage(named:"american-express")
            }
            else if card.cardType == DINERS_CLUB {
                cell.cardIcon.image = UIImage(named:"diners-club")
            }
            else if card.cardType == DISCOVER {
                cell.cardIcon.image = UIImage(named:"discover")
            }
            else if card.cardType == JCB {
                cell.cardIcon.image = UIImage(named:"jcb")
            }
            else {
                cell.cardIcon.image = UIImage(named:"visa")
            }
            cell.menuItems = nil
            cell.checkMarkIcon.isHidden = !card.isDefault
            cell.labelName.text = "***** \(card.number)"
            
            var paymentType = "Other"
            if card.paymentType == PAYMENT_TYPE_BUSINESS {
                paymentType = "Business"
            }
            else if card.paymentType == PAYMENT_TYPE_PERSONAL {
                paymentType = "Personal"
            }
            cell.labelPaymentType.text = paymentType
            
            return cell
        }
        else {
            var cashOutMethods:NSArray = GlobalData.shared.me?.profile.cashOutMethods as! NSArray
            var cashOutMethod:CashOutMethodModel  = cashOutMethods[indexPath.row] as! CashOutMethodModel
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CashOutMethodCollectionViewCell", for: indexPath) as! CashOutMethodCollectionViewCell
            cell.checkMarkIcon.isHidden = !cashOutMethod.isDefault
            cell.labelFee.text = String(cashOutMethod.fee)
            
            if indexPath.row < cashOutMethods.count - 1{
                cell.bottomLine.isHidden = false
            }
            else {
                cell.bottomLine.isHidden = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: CARD_CELL_HEIGHT)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
