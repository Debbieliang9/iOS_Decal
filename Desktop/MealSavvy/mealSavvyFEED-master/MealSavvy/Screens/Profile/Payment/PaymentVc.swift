//
//  PaymentVc.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 09/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class PaymentVc: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableViewData: UITableView!
    
    //MARK:- Other Variables
   var paymentData = Array<Dictionary<String,String>>()
   var plan_type = 1;

    //MARK:- View Controller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "show.cashamount" {
            let vc = segue.destination as! CashOutAmountViewController
            vc.isRequireDeposit = false
            vc.isDeposit = true
        }
    }

    //MARK:- IBACtions
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Other Helper Methods
    func configure() {
        paymentData = [["image": "History-1", "name": "Order History"],
             //   ["image": "Mask Group 16", "name": "Payment History"],
                ["image": "Mask Group 17", "name": "Payment Method"]
//                ["image": "cash_out", "name": "Cash Out"]
        ]
        tableViewData.register(UINib(nibName: "PaymentVCTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentVCTableViewCell")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

extension PaymentVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return paymentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = tableView.dequeueReusableCell(withIdentifier: "PaymentVCTableViewCell") as! PaymentVCTableViewCell
        returnCell.putDataIntoCell(data: paymentData[indexPath.row])
        return returnCell
    }
}

extension PaymentVc: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let moveToOrderHistoryVc = storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVc") as! OrderHistoryVc
            self.navigationController?.pushViewController(moveToOrderHistoryVc, animated: true)
        }
        else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "show.paymentlist", sender: nil)
        }
        else {
            self.performSegue(withIdentifier: "show.cashamount", sender: nil)
        }
    }
}
