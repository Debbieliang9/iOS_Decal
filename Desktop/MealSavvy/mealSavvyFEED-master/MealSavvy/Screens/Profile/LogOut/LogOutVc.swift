//
//  LogOutVc.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class LogOutVc: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var viewDisplayLogout: UIView!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    //MARK:- Other Variables
    
    //MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBAction
    
    @IBAction func tapNo(_ sender: UIButton) {
         btnYes.makeBorder(2, color:UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) ))
        btnYes.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        btnYes.backgroundColor = UIColor.white
        btnNo.backgroundColor = UIColor.getRGBColor(49, g: 170, b: 101)
        btnNo.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func tapYes(_ sender: UIButton) {
          btnNo.makeBorder(2, color:UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) ))
        btnNo.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        btnNo.backgroundColor = UIColor.white
        btnYes.backgroundColor = UIColor.getRGBColor(49, g: 170, b: 101)
        btnYes.setTitleColor(UIColor.white, for: UIControlState.normal)
        logout()
    }

    @IBAction func tapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Other Methods
    func configure() {
        btnNo.makeBorder(2, color:UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) ))
        btnYes.makeBorder(2, color:UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) ))
        btnNo.makeRoundCorner(15)
        btnYes.makeRoundCorner(15)
        viewDisplayLogout.addShadowWithRadius(radius: 2, cornerRadius: 5)
    }
    
    func logout(){
        SVProgressHUD.show()
        SocketService.shared.logout { (user, error) in
            SVProgressHUD.dismiss()
            print(user)
            print(error)
            if error == nil{
                GlobalData.shared.me  = nil
                let instance = self.storyboard?.instantiateViewController(withIdentifier: "AuthNavigationController") as! UINavigationController
                APP_DELEDATE.window?.rootViewController = instance
            }else{
                self.showOkAlert(error!)
            }
        }
    }

}
    

