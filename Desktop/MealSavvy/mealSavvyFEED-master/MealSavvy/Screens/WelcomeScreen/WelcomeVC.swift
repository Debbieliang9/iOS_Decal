//
//  WelcomeVC.swift
//  MealSavvy
//
//  Created by Sumit  Appsinvo on 19/09/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var bntSignin: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var page: UIPageControl!
    
    //MARK:- Injectable
    var data  = Array<Dictionary<String,String>>()
    
    //MARK:- UIViewController Life cycle
    override func viewDidLoad() {
        data = [[Constant.kIMAGE         : "download (1)",
                 Constant.kNAME          : "LOWEST PRICE",
                 Constant.kDESCRIPTION   : "Pay the lowest prices for\n restaurants located near you!"],
                [Constant.kIMAGE         : "download (2)",
                 Constant.kNAME          : "EAT FOR LESS",
                 Constant.kDESCRIPTION   : "save time and money\n with our meal plan!"],
                [Constant.kIMAGE         : "download (3)",
                 Constant.kNAME          : "GET ACCESS ",
                 Constant.kDESCRIPTION   : "Exclusive restaurant items\n available only on MealSavvy!"]]
        configuration()
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- UIButton Tap Action
    @IBAction func tapOnSignin(_ sender: UIButton) {
        let instance = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(instance, animated: true)
    }
    
    @IBAction func tapOnSignUp(_ sender: UIButton) {
        let instance = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        self.navigationController?.pushViewController(instance, animated: true)
    }
    
    //MARK:- Helper Methods
    func configuration(){
        btnSignup.makeRoundCorner()
        bntSignin.makeRoundCorner()
        bntSignin.makeBorder(1, color: Constant.kAPP_GREEN_COLOR)
    }
}

    //MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension WelcomeVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101) as! UIImageView
        let title = cell.viewWithTag(102) as! UILabel
        let description = cell.viewWithTag(103) as! UILabel
        print(self.data[indexPath.row][Constant.kIMAGE]!)
        img.image = UIImage(named : self.data[indexPath.row][Constant.kIMAGE]!)
        title.text  = self.data[indexPath.row][Constant.kNAME]!
        description.text = self.data[indexPath.row][Constant.kDESCRIPTION]!
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}



