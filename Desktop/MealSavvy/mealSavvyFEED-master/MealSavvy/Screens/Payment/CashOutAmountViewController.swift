//
//  CashOutAmountViewController.swift
//  MealSavvy
//
//  Created by iOS Developer on 10/9/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class CashOutAmountViewController: UIViewController, LedgerHelperDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewCashOut: UIView!
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyUnit: UILabel!
    @IBOutlet weak var txtBalance: UITextField!
    @IBOutlet weak var labelWarning: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewUnitPicker: UIView!
    @IBOutlet weak var viewUnitPickerOverlay: UIView!
    @IBOutlet weak var pickerUnit: UIPickerView!
    @IBOutlet weak var labelStep1: UILabel!
    @IBOutlet weak var labelStep2: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    var isDeposit:Bool!
    var isRequireDeposit:Bool!
    var isSkipLoading:Bool = false
    var cashOutNumber:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.viewContent.addGestureRecognizer(singleTap)
        self.hideUnitPicker(false)

        // Do any additional setup after loading the view.
        collectionView.register(DepositAmountCollectionViewCell.self, forCellWithReuseIdentifier: "DepositAmountCollectionViewCell")
        
        LedgerHelper.shared().delegate = self
        self.pickerUnit.delegate = LedgerHelper.shared()
        self.pickerUnit.dataSource = LedgerHelper.shared()
        self.txtBalance.delegate = self;
        
        self.collectionView.backgroundColor = UIColor.toolowSmokeBG()
        var frame:CGRect = self.collectionView.frame
        frame.size.height = self.getCollectionViewHeight(0)
        self.collectionView.frame = frame
        
        
        var minAmount:CGFloat = MIN_CASHOUT_AMOUNT
        
        if self.isRequireDeposit {
            minAmount = LedgerHelper.shared().minimumDepositAmount
        }
        else {
            if self.isDeposit {
                minAmount = MIN_DEPOSIT_AMOUNT
            }
        }
        labelWarning.text = String(format: "$%.2f or more available balance required to cash out.", minAmount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isDeposit {
            self.lblTitle.text = "Deposit"
            self.labelStep1.text = "Amount to deposit"
            self.labelStep2.text = "Method to deposit"
            self.labelDescription.text = "Amount to deposit:";// @"How much would you like to deposit?";
            
            if isSkipLoading == false {
                isSkipLoading = true
                cashOutNumber = MIN_DEPOSIT_AMOUNT
                if self.isRequireDeposit {
                    cashOutNumber = LedgerHelper.shared().minimumDepositAmount
                }
                
                txtBalance.placeholder = "At least \(LedgerHelper.shared().getFormatedMoney(cashOutNumber))"
                self.fillBalance()
            }
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
        else {
            
            self.lblTitle.text = "Cash Out"
            self.collectionView.isHidden = true
        }
        
        self.pickerUnit.reloadAllComponents()
        self.btnNext.isEnabled = self.isValidAmountToCashOut()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUpdateBalance), name: NSNotification.Name(rawValue: "NOTIFICATION_UPDATE_BALANCE"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NOTIFICATION_UPDATE_BALANCE"), object: nil)
        if isDeposit {
            removeObservers()
        }
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func fillBalance() {
        if isDeposit {
            if isRequireDeposit {
                if cashOutNumber < LedgerHelper.shared().minimumDepositAmount {
                    cashOutNumber = LedgerHelper.shared().minimumDepositAmount
                }
                txtBalance.placeholder = "At least \(LedgerHelper.shared().getFormatedMoney(LedgerHelper.shared().minimumDepositAmount))"
            } else {
                if cashOutNumber < MIN_DEPOSIT_AMOUNT {
                    cashOutNumber = MIN_DEPOSIT_AMOUNT
                }
                txtBalance.placeholder = "At least \(LedgerHelper.shared().getFormatedMoney(MIN_DEPOSIT_AMOUNT))"
            }
        } else {
            if cashOutNumber < MIN_CASHOUT_AMOUNT {
                cashOutNumber = MIN_CASHOUT_AMOUNT
            }
            txtBalance.placeholder = "At least \(LedgerHelper.shared().getFormatedMoney(MIN_CASHOUT_AMOUNT))"
        }
        txtBalance.text = LedgerHelper.shared().getFormatedMoney(cashOutNumber)
        labelCurrencyUnit.text = LedgerHelper.shared().getCurencyUnit()
        imageFlag.image = UIImage(named: LedgerHelper.shared().getCountryFlag())
    }
    
    private func getCollectionViewHeight(_ keyboardHeight:CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.height - (74.0 + collectionView.frame.origin.y + keyboardHeight)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        let money: CGFloat = cashOutNumber * LedgerHelper.shared().currentCurrency.rate
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        let result = formatter.string(from: Float(money) as NSNumber)
        txtBalance.text = result
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        self.perform(#selector(self.handleNextButton), with: nil, afterDelay: 0.2)
        
        return true
    }
    
    func getBalanceAmount() -> CGFloat {
        return cashOutNumber
    }
    
    @IBAction func onNext(_ sender: Any) {
        self.dismissKeyboard()
        self.hideUnitPicker(false)
        self.goCashOutMethod()
    }
    
    private func isValidAmountToCashOut() -> Bool {
        return true
    }
    
    private func goCashOutMethod() {
        if self.isValidAmountToCashOut() {
            self.performSegue(withIdentifier: "show.method", sender: nil)
        }
    }
    
    private func hideUnitPicker(_ animation:Bool) {
        var frame: CGRect = viewUnitPicker.frame
        frame.origin.y = UIScreen.main.bounds.size.height
        if animation {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.viewUnitPicker.frame = frame
            })
        } else {
            viewUnitPicker.frame = frame
        }
    }
    
    @objc func dismissKeyboard() {
        self.txtBalance.resignFirstResponder()
    }
    
    @objc func handleUpdateBalance() {
        self.fillBalance()
        self.collectionView.reloadData()
    }
    
    @objc func handleNextButton() {
        if let value = NumberFormatter().number(from: self.txtBalance.text!)  {
            cashOutNumber = LedgerHelper.shared().convert(toUSD: CGFloat(value))
            self.btnNext.isEnabled = isValidAmountToCashOut()
        }
    }
    
    @IBAction func didTouchCurrency(_ sender: Any) {
        self.dismissKeyboard()
        self.pickerUnit.reloadAllComponents()
        self.showUnitPicker(true)
    }
    
    private func showUnitPicker(_ animation:Bool) {
        var frame: CGRect = viewUnitPicker.frame
        frame.origin.y = 0
        if animation {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.viewUnitPicker.frame = frame
            })
        } else {
            viewUnitPicker.frame = frame
        }
    }
    
    @IBAction func didTouchPickerDone(_ sender: Any) {
        self.hideUnitPicker(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func getMoneyAtIndex(_ index:Int) -> CGFloat {
        var money:CGFloat = 0.0
        if self.isDeposit {
            money = MIN_DEPOSIT_AMOUNT
        }
        else {
            money = MIN_CASHOUT_AMOUNT
        }
        
        switch index {
        case 0:
            return money
        case 1:
            return money * 2
        case 2:
            return money * 4
        default:
            return money * 8
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "show.method" {
            let vc = segue.destination as! CashOutMethodViewController
            vc.isDeposit = self.isDeposit
            vc.isRequireDeposit = self.isRequireDeposit
            vc.amountToCashOut = cashOutNumber
        }
    }
}

extension CashOutAmountViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "DepositAmountCollectionViewCell", for: indexPath) as! DepositAmountCollectionViewCell
        
        var money:CGFloat = self.getMoneyAtIndex(indexPath.row)
        cell.label.text = LedgerHelper.shared().getFormatedMoney(money).replacingOccurrences(of: ".00", with: "")
        
        cell.disableItem(isDisable: (isRequireDeposit && money < LedgerHelper.shared().minimumDepositAmount))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: CELL_HEIGHT)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var amount: CGFloat = getMoneyAtIndex(indexPath.row)
        if isRequireDeposit {
            if amount < LedgerHelper.shared().minimumDepositAmount {
                return
            }
        }
        cashOutNumber = getMoneyAtIndex(indexPath.row)
        fillBalance()
        goCashOutMethod()
    }
}
