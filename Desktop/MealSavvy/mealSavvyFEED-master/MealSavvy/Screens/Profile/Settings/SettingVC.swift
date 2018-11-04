//
//  SettingVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var tableViewData: UITableView!
    //MARK:- IBActions
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Other Variables
    var count = 0
    var data = Array<Dictionary<String,String>>()
    
    // MARK:- UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Other Helper Methods
    func configure() {
        data = [["image" : "Profile-1", "Name" : "Profile"],
                ["image" : "change-pass-1", "Name" : "Change Password"],
                ["image" : "notification-1", "Name" : "Allow Notifications"]]
        tableViewData.register(UINib(nibName: "SettingVCTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingVCTableViewCell")
    }
}
extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "SettingVCTableViewCell") as! SettingVCTableViewCell
        if indexPath.row == 0 {
            returnCell.SwitchEnable.isHidden = true
            returnCell.imgRightArrow.image = UIImage.init(named: "right-arrow")
        } else if indexPath.row == 1 {
            returnCell.SwitchEnable.isHidden = true
            returnCell.imgRightArrow.image = UIImage.init(named: "right-arrow")
        } else if indexPath.row == 2 {
            returnCell.SwitchEnable.isHidden = false
        }
        returnCell.putDataIntoCell(data: data[indexPath.row], index: indexPath.row)
        return returnCell
    }
}
extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let moveToProfileVc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(moveToProfileVc, animated: true)
        }
        if indexPath.row == 1 {
            let moveToChangePasswordVC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(moveToChangePasswordVC, animated: true)
        }
        if indexPath.row == 2{
            let returnSettingCell = tableView.cellForRow(at: indexPath) as! SettingVCTableViewCell
            returnSettingCell.SwitchEnable.isOn =  !returnSettingCell.SwitchEnable.isOn
        }
    }
}
