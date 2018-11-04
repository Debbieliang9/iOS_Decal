//
//  MealTrayVc.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 10/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class MealTrayVc: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var btnCreditCard: UIButton!
    @IBOutlet weak var viewToken: UIView!
    @IBOutlet weak var imgToken: UIImageView!
    @IBOutlet weak var imgCreditcard: UIImageView!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var btnToken: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var tableviewData: UITableView!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var totalTokenImgView: UIImageView!
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var lblAvailableToken: UILabel!
    @IBOutlet weak var lblMealTray: UILabel!
    
    @IBOutlet weak var cartHeightConstraint: NSLayoutConstraint!
    
    var arrayCuisineModelDetail = [ServiceModel]()
    var tokenPay:Bool!
    var tokenTotal:Int!
    var priceTotal:Float!
    var curBook:BookModel!
    var techId:String = ""
    //MARK:- Other defined Variables
    
    //MARK:- View Controller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func calcTotal() {
        var subtotal = 0
        priceTotal = 0.0
        for eachCuisine:ServiceModel in arrayCuisineModelDetail {
            subtotal = subtotal + Int(eachCuisine.tokens)!
            priceTotal = priceTotal + eachCuisine.price
        }
        tokenTotal = subtotal
        if GlobalData.shared.me?.profile == nil {
            self.totalTokenImgView.isHidden = true
            tokenPay = false
            self.lblSubtotal.text = "$\(String(format: "%.2f", priceTotal))"
        }
        else {
            if self.tokenPay == true {
                self.totalTokenImgView.isHidden = false
                self.lblSubtotal.text = String(tokenTotal)
            }
            else {
                self.totalTokenImgView.isHidden = true
                self.lblSubtotal.text = "$\(String(format: "%.2f", priceTotal))"
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.techId = ""
        arrayCuisineModelDetail.removeAll()
        
        getUserInfo()

        if GlobalData.shared.me?.cart != nil {
            lblMealTray.text = String((GlobalData.shared.me?.cart.count)!)
            arrayCuisineModelDetail = (GlobalData.shared.me?.cart)!
            cartHeightConstraint.constant = CGFloat(arrayCuisineModelDetail.count * 80) + CGFloat(97)
            
            self.calcTotal()
        }
        if GlobalData.shared.me?.profile == nil {
            self.totalTokenImgView.isHidden = true
            tokenPay = false
            self.lblSubtotal.text = "$\(String(format: "%.2f", priceTotal))"
            self.selectTapCreditCard()
        }
        else {
            if GlobalData.shared.me?.profile.subscriber == true {
                
                if GlobalData.shared.me?.profile.subscriberInfo.remainingToken != nil {
                    
                    print(GlobalData.shared.me?.profile.subscriberInfo.remainingToken)
                    
                    if (GlobalData.shared.me?.profile.subscriberInfo.remainingToken)! < tokenTotal {
                        self.selectTapCreditCard()
                    }
                    else {
                        self.totalTokenImgView.isHidden = false
                        tokenPay = true
                        self.lblSubtotal.text = String(tokenTotal)
                        self.selectTapToken()
                    }
                }
                else {
                    self.selectTapCreditCard()
                }
            }
            else {
                self.totalTokenImgView.isHidden = true
                tokenPay = false
                self.lblSubtotal.text = "$\(String(format: "%.2f", priceTotal))"
                self.selectTapCreditCard()
            }
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
                    if GlobalData.shared.me?.profile.subscriberInfo.remainingToken != nil {
                        self.lblAvailableToken.text = "\((GlobalData.shared.me?.profile.subscriberInfo.remainingToken)!)"
                    }
                }
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Event Handler
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        
        if GlobalData.shared.me?.profile.subscriberInfo.remainingToken == 0 || GlobalData.shared.me?.profile.subscriberInfo.remainingToken == nil ||
            (GlobalData.shared.me?.profile.subscriberInfo.remainingToken)! < tokenTotal {
            if self.tokenPay == true {
                SVProgressHUD.showError(withStatus: "You do not have enough Tokens.")
                return
            }
        }
        
        if GlobalData.shared.me?.profile.creditCards.count == 0 && self.tokenPay == false
        {
            SVProgressHUD.showError(withStatus: "Please add a card.")
            return
        }
        
        SVProgressHUD.show(withStatus: "Please wait ...")
        
        let params = ["date":Date().convertToString("YYYY-MM-dd"),
                      "service_id": arrayCuisineModelDetail[0].serviceId,
                      "current_time":Date().convertToString("YYYY-MM-dd hh:mm:ss")] as [String:Any]
        SocketService.shared.getTimeSlot(arrayCuisineModelDetail[0].serviceId) { (technician_id, err) in
            
            if self.techId != "" {
                return
            }
            self.techId = technician_id!
            
            if technician_id != "" && technician_id != nil {
                
                if self.tokenPay == false {
                    SocketService.shared.bookingService(self.arrayCuisineModelDetail, comment: self.txtComment.text!, price:self.priceTotal, technicianId: technician_id!) { (book, error) in
                        
                        if let _ = error{
                            SVProgressHUD.showError(withStatus: error)
                        }else{
                            SVProgressHUD.dismiss()
                            self.curBook = book
                        }
                        GlobalData.shared.me?.cart.removeAll()

                        self.performSegue(withIdentifier: "show.status", sender: nil)
                    }
                }
                else {
                    SocketService.shared.bookWithToken((GlobalData.shared.me?.cart)!, comment: self.txtComment.text!, price:self.priceTotal, technicianId: technician_id!) { (book, error) in
                        if let _ = error{
                            SVProgressHUD.showError(withStatus: error)
                        }else{
                            SVProgressHUD.dismiss()
                            self.curBook = book
                        }
                        GlobalData.shared.me?.cart.removeAll()

                        self.performSegue(withIdentifier: "show.status", sender: nil)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "show.status" {
            let vc = segue.destination as! CustomerStatusVC
            vc.services = self.arrayCuisineModelDetail
            vc.comment = txtComment.text
            vc.isFrom = "book"
            if self.curBook != nil {
                vc.book = self.curBook
            }
        }
    }
    
    private func selectTapToken() {
        btnCreditCard.makeRoundCorner(5)
        btnCreditCard.makeBorder(1, color: UIColor.black)
        imgCreditcard.image = UIImage.init(named: "Ellipse 1")
        viewCreditCard.backgroundColor = UIColor.white
        imgToken.image = UIImage.init(named: "Path 11")
        btnToken.makeBorder(1, color: UIColor.getRGBColor(44, g: 143, b: 91))
        viewToken.backgroundColor = UIColor.init(red: 44/255.0 , green: 143/255.0 , blue: 91/255.0 , alpha: 0.3)
        lblToken.isHidden = false
        totalTokenImgView.isHidden = false
        self.lblSubtotal.text = String(tokenTotal)
        
        self.tokenPay = true
        tableviewData.reloadData()
    }
    
    private func selectTapCreditCard() {
        btnToken.makeRoundCorner(5)
        btnToken.makeBorder(1, color: UIColor.black)
        viewToken.backgroundColor = UIColor.white
        imgToken.image = UIImage.init(named: "Ellipse 1")
        imgCreditcard.image = UIImage.init(named: "Path 11")
        btnCreditCard.makeBorder(1, color: UIColor.getRGBColor(44, g: 143, b: 91))
        viewCreditCard.backgroundColor = UIColor.init(red: 44/255.0 , green: 143/255.0 , blue: 91/255.0 , alpha: 0.3)
        self.lblToken.isHidden = true
        totalTokenImgView.isHidden = true
        self.lblSubtotal.text = "$\(String(format: "%.2f", priceTotal))"
        
        self.tokenPay = false
        tableviewData.reloadData()
    }

    @IBAction func tapToken(_ sender: UIButton) {
        self.selectTapToken()
        
    }

    @IBAction func tapCreditCard(_ sender: UIButton) {
        self.selectTapCreditCard()
    }
    
    //MARK:- Other Helper Methods
    func configure() {
        
        tableviewData.register(UINib(nibName: "MealTrayTableViewCell", bundle: nil), forCellReuseIdentifier: "MealTrayTableViewCell")
        btnConfirm.addShadowWithRadius(radius: 2, cornerRadius: 20)
        btnToken.makeBorder(1, color: UIColor.black)
        btnCreditCard.makeBorder(1, color: UIColor.black)
        txtComment.makeBorder(1, color: UIColor.init(rgb:0x999999, a:1.0))
        btnToken.makeRoundCorner(5)
        btnCreditCard.makeRoundCorner(5)
    }
}

//MARK:- Extension
extension MealTrayVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCuisineModelDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "MealTrayTableViewCell") as! MealTrayTableViewCell
        returnCell.cellIndex = indexPath.row
        returnCell.delegate = self
        returnCell.configure(foodDetail: arrayCuisineModelDetail[indexPath.row], tokenPay: tokenPay)
        return returnCell
    }
}

extension MealTrayVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MealTrayVc : MealTrayTableViewCellDelegate {
    func onRemove(_ cellIndex: Int!) {
        GlobalData.shared.me?.cart.remove(at: cellIndex)
        arrayCuisineModelDetail = (GlobalData.shared.me?.cart)!
        lblMealTray.text = String((GlobalData.shared.me?.cart.count)!)
        self.calcTotal()
        tableviewData.reloadData()
    }
}
