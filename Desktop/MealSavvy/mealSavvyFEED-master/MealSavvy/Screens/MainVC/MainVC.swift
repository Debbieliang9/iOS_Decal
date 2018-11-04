//
//  MainVC.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 06/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire
import SVProgressHUD

class MainVC: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewTab: UIView!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var foodListCollectionView: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var remainingTokenLabel: UILabel!
    @IBOutlet weak var mealTrayLabel: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    
    //MARK:- Other Variables
    var tabData = [String]()
    var count: Int = 0
    var selectedIndex: Int = 0
    
    private var cuisines = [CuisineModel] ()
    private var restaurants = [RestaurantModel] ()
    private var favorites = [RestaurantModel] ()
    
    // MARK:- View controller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tabCollectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onReceivedSocketConnected), name: NotificationNames.socketConnected, object: nil)
        
        if SocketService.shared.socketStatus == .connected {
            onReceivedSocketConnected()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getUserInfo()
        
        if GlobalData.shared.me?.cart == nil {
        }
        else {
            mealTrayLabel.text = String((GlobalData.shared.me?.cart.count)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationNames.socketConnected, object: nil)
    }

    // MARK: - Event Handler
    @IBAction func onClickMealTray(_ sender: Any) {
        
        if GlobalData.shared.me?.cart == nil || GlobalData.shared.me?.cart.count == 0 {
            return
        }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MealTrayVc") else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Other Helper Methods
    func configure() {
        tabData = ["Cuisines", "Restaurants", "Favorites"]
        viewTab.addShadow(radius: 10)
        txtSearch.delegate = self
        self.navigationItem.backBarButtonItem = nil

        //btnCheckOut.setTitle("\(GlobalData.shared.me?.profile.subscriberInfo.remainingMeals)", for: .normal)
        //remainingTokenLabel.text = "\(GlobalData.shared.me?.profile.subscriberInfo.remainingToken)"
    }
    
    // MARK: - Select Current Tab
    private func setCurrentTab(_ selectedIndex: Int) {
        if self.selectedIndex != selectedIndex {
            self.selectedIndex = selectedIndex
            switch selectedIndex {
            case 0:
                getCuisines ()
                break
            case 1:
                getRestaurants ()
                break
            default:
                getFavorites()
                break
            }
            
            tabCollectionView.reloadData()
            foodListCollectionView.reloadData()
        }
    }
    
    // MARK: - Communication Handler
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
                    self.setUserInfo()
            }
        }
    }
    
    private func getCuisines () {
        /*
        if cuisines.count == 0 {
            SVProgressHUD.show(withStatus: "Please wait ...")
        }
        */
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.getCuisines((txtSearch.text?.trim())!,
                                         location: GlobalData.shared.userLocation) { (cuisines, error) in
                                            if let _ = error {
                                                SVProgressHUD.showError(withStatus: error)
                                            } else {
                                                SVProgressHUD.dismiss()
                                                self.cuisines.removeAll()
                                                self.cuisines.append(contentsOf: cuisines!)
                                                self.foodListCollectionView.reloadData()
                                            }
        }
    }
    
    private func searchCuisines () {
        /*
         if cuisines.count == 0 {
         SVProgressHUD.show(withStatus: "Please wait ...")
         }
         */
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.searchCuisines((txtSearch.text?.trim())!,
                 location: GlobalData.shared.userLocation) { (cuisines, error) in
                    if let _ = error {
                        SVProgressHUD.showError(withStatus: error)
                    } else {
                        SVProgressHUD.dismiss()
                        self.cuisines.removeAll()
                        self.cuisines.append(contentsOf: cuisines!)
                        self.foodListCollectionView.reloadData()
                    }
        }
    }
    
    private func getRestaurants () {
        /*
        if restaurants.count == 0 {
            SVProgressHUD.show(withStatus: "Please wait ...")
        }
        */
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.getRestaurants((txtSearch.text?.trim())!,
                location: GlobalData.shared.userLocation) { (restaurants, error) in
                    if let _ = error {
                        SVProgressHUD.showError(withStatus: error)
                    } else {
                        SVProgressHUD.dismiss()
                        self.restaurants.removeAll()
                        self.restaurants.append(contentsOf: restaurants!)
                        self.foodListCollectionView.reloadData()
                    }
        }
    }
    
    private func getFavorites () {
        /*
        if favorites.count == 0 {
            SVProgressHUD.show(withStatus: "Please wait ...")
        }
        */
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.getFavorites((txtSearch.text?.trim())!,
                      location: GlobalData.shared.userLocation) { (favorites, error) in
                        if let _ = error {
                            SVProgressHUD.showError(withStatus: error)
                        } else {
                            SVProgressHUD.dismiss()
                            self.favorites.removeAll()
                            self.favorites.append(contentsOf: favorites!)
                            self.foodListCollectionView.reloadData()
                        }
        }
    }
    
    private func searchFavorites () {
        /*
         if favorites.count == 0 {
         SVProgressHUD.show(withStatus: "Please wait ...")
         }
         */
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.searchFavorites((txtSearch.text?.trim())!,
              location: GlobalData.shared.userLocation) { (favorites, error) in
                if let _ = error {
                    SVProgressHUD.showError(withStatus: error)
                } else {
                    SVProgressHUD.dismiss()
                    self.favorites.removeAll()
                    self.favorites.append(contentsOf: favorites!)
                    self.foodListCollectionView.reloadData()
                }
        }
    }

    // MARK: - Set User Info Handler
    private func setUserInfo () {
        
        if GlobalData.shared.me?.profile.subscriberInfo.remainingToken == nil {
            return
        }
        
        // remaining tokens
        remainingTokenLabel.text = "\((GlobalData.shared.me?.profile.subscriberInfo.remainingToken)!)"
        
        // meal tray
//        mealTrayLabel.text = "\((GlobalData.shared.me?.profile.subscriberInfo.remainingMeals)!)"
    }
    
    // MARK: - Search Handler
    private func searchData () {
        switch selectedIndex {
        case 0:
            searchCuisines()
            break
        case 1:
            getRestaurants()
            break
        default:
            searchFavorites()
//            getFavorites()
            break
        }
    }
    
    // MARK: - Private Handler
    @objc func onReceivedSocketConnected () {
        getCuisines()
        getUserInfo ()
    }
}

//MARK:- Extension
extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabCollectionView {
            return tabData.count
        }

        var count = 0
        switch selectedIndex {
        case 0:
            count = cuisines.count
            break
        case 1:
            count = restaurants.count
            break
        default:
            count = favorites.count
            break
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCollectionView {
            let returnTabCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
            returnTabCell.configure(tabData: tabData, index: indexPath.row,selecedIndex: selectedIndex)
            return returnTabCell
        }
        
        let foodListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodListCell", for: indexPath) as! FoodListCell
        switch selectedIndex {
        case 0:
            foodListCell.cuisine = cuisines[indexPath.item]
            break
        case 1:
            foodListCell.restaurant = restaurants[indexPath.item]
            break
        default:
            foodListCell.favorite = favorites[indexPath.item]
            break
        }
        return foodListCell
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            let screenWidth = UIScreen.main.bounds.width
            let scaleFactor = (screenWidth/3) - 6
            return CGSize(width: scaleFactor, height: 50)
        }
        
        let screenWidth = foodListCollectionView.frame.width
        let scaleFactor = (screenWidth/2) - 6
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            setCurrentTab(indexPath.item)
            return
        }
        if collectionView == foodListCollectionView {
            let moveToGetFoodDetailVC = storyboard?.instantiateViewController(withIdentifier: "GetFoodDetailVC") as! GetFoodDetailVC
            moveToGetFoodDetailVC.foodType = selectedIndex
            if selectedIndex == 0 {
                moveToGetFoodDetailVC.cuisine = self.cuisines[indexPath.row]
            }
            else if selectedIndex == 1{
                moveToGetFoodDetailVC.restuarnt = self.restaurants[indexPath.row]
            }
            self.navigationController?.pushViewController(moveToGetFoodDetailVC, animated: true)
        }
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchData ()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchData()
    }
}

