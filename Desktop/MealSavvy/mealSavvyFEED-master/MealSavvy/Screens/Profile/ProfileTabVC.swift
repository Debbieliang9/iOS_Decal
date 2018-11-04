//
//  ProfileVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileTabVC: UIViewController {
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var helpContent: UIWebView!
    
    
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewMonthlyToken: UIView!
    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var tableViewData: UITableView!
    // MARK:- Other Variables
    var data = Array<Dictionary<String,String>>()
    
    // MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //        configure()
        data = [["image": "Mask Group 10", "Name" : "Payment"],
                ["image": "Mask Group 9", "Name" : "Settings"],
                ["image": "Mask Group 11", "Name" : "Help"],
                // ["image": "Mask Group 15", "Name" : "Be a Seller"],
            ["image": "Mask Group 13", "Name" : "Log Out"]]
        
        tableViewData.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        imgUserImage.makeRounded()
        viewMonthlyToken.addShadowWithRadius(radius: 2, cornerRadius: 5)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.helpView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.helpView.isHidden = true
        
        self.getUserInfo()
    }
    
    @IBAction func onHideHelp(_ sender: Any) {
        self.helpView.isHidden = true
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
                                                self.configure()
                                            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- IBActions
    
    // MARK:- Other Helper Methods
    func configure() {
        
        if GlobalData.shared.me?.profile != nil {
            let name = "\(GlobalData.shared.me?.profile.firstName as? String ?? "") \(GlobalData.shared.me?.profile.lastName as? String ?? "")"
            lblName.text = name
            
            let imgs = GlobalData.shared.me?.profile.images
            
            if let url = URL.init(string: imgs?.first as? String ?? ""){
                imgUserImage.af_setImage(withURL: url, placeholderImage: UIImage.init(named: "001-user-2") )
            }else{
                imgUserImage.image = UIImage.init(named: "001-user-2")
            }
            
            if GlobalData.shared.me?.profile.subscriberInfo.tokens != nil {
                lblToken.text = "\((GlobalData.shared.me?.profile.subscriberInfo.tokens)!)"
            }
            else {
                lblToken.text = "0"
            }
        }
    }
}

extension ProfileTabVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        returnCell.putDataIntoCell(data: data[indexPath.row])
        return returnCell
    }
}

extension ProfileTabVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let moveToPaymentVc = storyboard?.instantiateViewController(withIdentifier: "PaymentVc") as! PaymentVc
            self.navigationController?.pushViewController(moveToPaymentVc, animated: true)
        }else if indexPath.row == 1 {
            let moveToSettingVC = storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.navigationController?.pushViewController(moveToSettingVC, animated: true)
        }else if indexPath.row == 2 {
            SVProgressHUD.show()
            self.helpView.isHidden = false
            SocketService.shared.getHelpText(completion: { (msg, error) in
                SVProgressHUD.dismiss()
                if error == nil{
                    self.helpContent.loadHTMLString(msg, baseURL: nil)
                    //                    self.showOkAlert(msg)
                    return
                }else{
                    self.showOkAlert(error!)
                }
            })
        }
            
        else if indexPath.row == 3 {
            let moveToLogOutVC = storyboard?.instantiateViewController(withIdentifier: "LogOutVc") as! LogOutVc
            moveToLogOutVC.modalPresentationStyle = .overFullScreen
            self.present(moveToLogOutVC, animated: true, completion: nil)
        }
    }
}
