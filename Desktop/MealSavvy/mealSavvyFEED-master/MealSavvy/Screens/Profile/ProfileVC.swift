//
//  ProfileVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileVC: UIViewController {
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageAvatar: FSImageView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelBirthdate: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelStreet: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var viewAmbassadorContent: UIView!
    @IBOutlet weak var viewAmbassador: UIView!
    @IBOutlet weak var ambassdorAvatar: FSImageView!
    @IBOutlet weak var labelAmbassdorHid: UILabel!
    @IBOutlet weak var labelAmbassdorFullName: UILabel!
    
    // MARK:- Other Variables
    var data = Array<Dictionary<String,String>>()
    
    // MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- IBActions
    
    // MARK:- Other Helper Methods
    func configure() {
        
        if GlobalData.shared.me?.profile != nil {
            labelFirstName.text = GlobalData.shared.me?.profile.firstName
            labelLastName.text = GlobalData.shared.me?.profile.lastName
            
            let imgs = GlobalData.shared.me?.profile.images
            
            if let url = URL.init(string: imgs?.first as? String ?? ""){
                imageAvatar.af_setImage(withURL: url, placeholderImage: UIImage.init(named: "001-user-2") )
            }else{
                imageAvatar.image = UIImage.init(named: "001-user-2")
            }
            
            var dateComponents = DateComponents()
            dateComponents.year = GlobalData.shared.me?.profile.dobYear
            dateComponents.month = GlobalData.shared.me?.profile.dobMonth
            dateComponents.day = GlobalData.shared.me?.profile.dobDay
            
            let useCalendar = Calendar.current
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "MM dd, YYYY"
            
            labelBirthdate.text = formatter.string(from: useCalendar.date(from: dateComponents)!)
            labelGender.text = GlobalData.shared.me?.profile.sex
            labelCity.text = GlobalData.shared.me?.profile.city
            labelStreet.text = GlobalData.shared.me?.profile.address
            labelPhone.text = GlobalData.shared.me?.profile.phone
            labelEmail.text = GlobalData.shared.me?.profile.email
            labelAmbassdorHid.text = GlobalData.shared.me?.profile.ambassadorHid
            let name = "\(GlobalData.shared.me?.profile.firstName as? String ?? "") \(GlobalData.shared.me?.profile.lastName as? String ?? "")"
            labelAmbassdorFullName.text = name       
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
    
    @IBAction func onEdit(_ sender: Any) {
    }    
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        returnCell.putDataIntoCell(data: data[indexPath.row])
        return returnCell
    }
}
extension ProfileVC: UITableViewDelegate {
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
            SocketService.shared.getHelpText(completion: { (msg, error) in
                SVProgressHUD.dismiss()
                if error == nil{
                    self.showOkAlert(msg)
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
