//
//  AddCashOutMethodViewController.swift
//  MealSavvy
//
//  Created by iOS Developer on 10/9/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class AddCashOutMethodViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(ManagePaymentCollectionViewCell.self, forCellWithReuseIdentifier: "ManagePaymentCollectionViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddCashOutMethodViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LedgerHelper.shared().toolowCashOutMethods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ManagePaymentCollectionViewCell", for: indexPath) as! ManagePaymentCollectionViewCell
        cell.labelRight.textColor = UIColor.toolowOrange()
        return cell
    }
}
