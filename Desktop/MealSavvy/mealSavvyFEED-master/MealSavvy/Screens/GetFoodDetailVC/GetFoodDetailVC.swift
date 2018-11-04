//
//  GetFoodDetailVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 07/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class GetFoodDetailVC: UIViewController {
     // MARK:- IBOutlets
    
    @IBOutlet weak var widthOfCollecctionTYpe: NSLayoutConstraint!
    @IBOutlet weak var imgbg: UIImageView!
    @IBOutlet weak var lblBannerFoodType: UILabel!
    @IBOutlet weak var collectionViewFoodDetail: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewFoodType: UIView!
    @IBOutlet weak var collectionViewFoodType: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblMealTray: UILabel!

    // MARK:- Other Variable
    var tabFoodData = [String]()
    var foodDetailList = Array<Dictionary<String,String>>()
    var selectedIndex: Int = 0
    var cuisine = CuisineModel()
    var restuarnt = RestaurantModel()
    var arrType = [SubCuisine]()
    var arrayCuisineModelDetail = [ServiceModel]()
    var foodType:Int = 0
    
    
    // MARK:- ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        if foodType == 0 {
            getSubCuisines()
        }
        else {
            getAllItems()
        }
        manageWidthOfCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GlobalData.shared.me?.cart != nil {
            self.lblMealTray.text = String((GlobalData.shared.me?.cart.count)!)
        }
    }
    
    @IBAction func onMealTray(_ sender: Any) {
        if GlobalData.shared.me?.cart == nil || GlobalData.shared.me?.cart.count == 0 {
            return
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MealTrayVc") else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
     // MARK:- Other Helper Variables
    
    func configure(){
        collectionViewFoodDetail.register(UINib(nibName: "foodDetailListCell", bundle: nil), forCellWithReuseIdentifier: "foodDetailListCell")
        viewFoodType.addShadow(radius: 10)
        txtSearch.delegate = self
        collectionViewFoodDetail.delegate = self
        collectionViewFoodDetail.dataSource = self
        collectionViewFoodType.dataSource = self
        collectionViewFoodType.delegate = self
        lblBannerFoodType.text = self.cuisine.name!
        if self.foodType == 0 {
            imgbg.af_setImage(withURL: URL.init(string: self.cuisine.image!)!, placeholderImage: UIImage(named : "sharon-chen-352895-unsplash"))
        }
    }
    // MARK:- IBAction
    
    @IBAction func tapBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllItems() {
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.getSupplierDetail(restuarnt.hid) { (arrayType, error) in
            if let _ = error{
                SVProgressHUD.showError(withStatus: error)
            }else{
                SVProgressHUD.dismiss()
                self.arrayCuisineModelDetail = arrayType!
                
                self.manageWidthOfCollection()
                self.collectionViewFoodType.reloadData()
                self.collectionViewFoodDetail.reloadData()
            }
        }
    }
    
    
   func getSubCuisines(){
    SVProgressHUD.show(withStatus: "Please wait ...")
    SocketService.shared.getSubCuisines((txtSearch.text?.trim())!, tag: cuisine.tag, location:  GlobalData.shared.userLocation) { (arrayType, error) in
        if let _ = error{
            SVProgressHUD.showError(withStatus: error)
        }else{
            SVProgressHUD.dismiss()
            self.arrType = arrayType!
            
            if arrayType == nil || arrayType?.count == 0 {
                return
            }
            self.arrayCuisineModelDetail = arrayType![0].services
            self.manageWidthOfCollection()
            self.collectionViewFoodType.reloadData()
            self.collectionViewFoodDetail.reloadData()
        }
      }
    }
    
    func manageWidthOfCollection(){
         let scaleFactor = (self.view.frame.width/4) - 6
        if scaleFactor * CGFloat(self.arrType.count) < self.view.frame.width-20{
            self.widthOfCollecctionTYpe.constant = scaleFactor * CGFloat(self.arrType.count)
        }else{
            self.widthOfCollecctionTYpe.constant = self.view.frame.width-20
        }
        self.view.layoutIfNeeded()
        self.collectionViewFoodType.reloadData()
    }
}

extension GetFoodDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewFoodType {
            print()
            return arrType.count
        }
            return arrayCuisineModelDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewFoodType {
            let returnFoodData = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodDataCell", for: indexPath) as! FoodDataCell
            returnFoodData.configure(foodTypeData: self.arrType[indexPath.row], index: indexPath.row, selecedIndex: selectedIndex)
            return returnFoodData
        }
        let returnFoodDetail = collectionView.dequeueReusableCell(withReuseIdentifier: "foodDetailListCell", for: indexPath) as! foodDetailListCell
        returnFoodDetail.configure(foodDetail: self.arrayCuisineModelDetail[indexPath.row])
        return returnFoodDetail
    }
}

extension GetFoodDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewFoodType {
            let screenWidth = UIScreen.main.bounds.width
            let scaleFactor = (screenWidth/4) - 6
            return CGSize(width: scaleFactor, height: 50)
        }
        let screenWidth = collectionViewFoodDetail.frame.width
        let scaleFactor = (screenWidth)
        return CGSize(width: scaleFactor, height: 100)
    }
}


extension GetFoodDetailVC:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewFoodType {
           let returnFoodData = collectionView.cellForItem(at: indexPath) as! FoodDataCell
            selectedIndex = indexPath.row
            self.arrayCuisineModelDetail = arrType[indexPath.row].services
            collectionViewFoodType.reloadData()
            collectionViewFoodDetail.reloadData()
        } else if collectionView == collectionViewFoodDetail {
            
            let cellService:ServiceModel = self.arrayCuisineModelDetail[indexPath.row]
            if cellService.allSold == true {
                return
            }
           
            let moveToAddTray = storyboard?.instantiateViewController(withIdentifier: "AddToTrayView") as! AddToTrayView
            moveToAddTray.instance = self
            moveToAddTray.foodDetail =  self.arrayCuisineModelDetail[indexPath.row]
            print(GlobalData.shared.me?.cart)
            moveToAddTray.modalPresentationStyle = .overFullScreen
            self.present(moveToAddTray,animated: true, completion: nil)
        }
    }
}

extension GetFoodDetailVC: UITextFieldDelegate {
    
}
