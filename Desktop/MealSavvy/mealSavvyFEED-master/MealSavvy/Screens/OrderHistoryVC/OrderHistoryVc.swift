//
//  OrderHistoryVc.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 10/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrderHistoryVc: UIViewController {

    //MARK:- IBOutlets
        @IBOutlet weak var tableViewData: UITableView!
    //MARK:- Other Variables
    var orderHistoryData = [PaymentHistoryModel]()
    var selectedHistory: PaymentHistoryModel!
    
    //MARK:- View Controller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getPaymentOrder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- IBAction
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "show.order" {
            let vc = segue.destination as! CustomerStatusVC
            vc.history = selectedHistory
            vc.isFrom = "history"
        }
    }
    
    //MARK:- Other Helper Methods
    
    func configure() {
        tableViewData.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderHistoryTableViewCell")
        tableViewData.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func getPaymentOrder(){
        SVProgressHUD.show(withStatus: "Please wait ...")
        SocketService.shared.getPaymentHistory { (payments, error) in
            if let _ = error {
                SVProgressHUD.showError(withStatus: error)
            } else {
                SVProgressHUD.dismiss()
                self.orderHistoryData.removeAll()
                self.orderHistoryData.append(contentsOf: payments!)
                self.tableViewData.reloadData()
            }
        }
    }    
}


extension OrderHistoryVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
        returnCell.putDataIntoCell(data: orderHistoryData[indexPath.row])
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHistory = orderHistoryData[indexPath.row]
        self.performSegue(withIdentifier: "show.order", sender: nil)
    }
}
extension OrderHistoryVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
