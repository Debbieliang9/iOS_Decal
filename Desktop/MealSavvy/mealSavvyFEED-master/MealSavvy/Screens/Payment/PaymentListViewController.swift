//
//  PaymentListViewController.swift
//  MealSavvy
//
//  Created by iOS Developer on 10/8/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit

class PaymentListViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewAddPayment: UIView!
    @IBOutlet weak var buttonAddPayment: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchAddPayment(_ sender: Any) {
        self.performSegue(withIdentifier: "show.detail", sender: nil)
    }
    
    @IBAction func onBack(_ sender: Any) {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
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

extension PaymentListViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if GlobalData.shared.me?.profile == nil {
            return 1
        }
        else {
            return (GlobalData.shared.me?.profile.creditCards.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
   
}

//
//open class PalanceCollectionViewCell : UICollectionViewCell{
//    open var checkMarkIcon = UIImageView()
//    open var rightArrowIcon = UIImageView()
//    open var labelPalance = UILabel()
//    open var labelPaymentType = UILabel()
//    open var bottomLine = UIView()
//    fileprivate final let LabelWidth : CGFloat = 100
//    fileprivate final let CardWidth : CGFloat = 50
//    fileprivate final let MarginLeftRight : CGFloat = 10
//    fileprivate final let CheckMarkIconWidth : CGFloat = 20
//    fileprivate final let RightArrowIconWidth : CGFloat = 8
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.white
//        checkMarkIcon.image = UIImage(named: "icon-check-mark")
//        labelPalance.textAlignment = .right
//        labelPalance.textColor = UIColor.toolowGreen()
//
//        self.labelPaymentType.textColor = UIColor.darkGray
//        self.labelPaymentType.font = MBUtils.getToolowFontSize(15)
//        self.labelPaymentType.text = "Ledger"
//        rightArrowIcon.image = UIImage(named: "right-arrow-gray-16x28")
//        self.contentView.addSubview(checkMarkIcon)
//        self.contentView.addSubview(labelPaymentType)
//        self.contentView.addSubview(labelPalance)
//        self.contentView.addSubview(rightArrowIcon)
//        bottomLine.backgroundColor = UIColor.lightGray
//        bottomLine.isHidden = true
//        self.addSubview(bottomLine)
//        layoutSubviews()
//    }
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        checkMarkIcon.frame = CGRect(x: MarginLeftRight , y: 5, width: CheckMarkIconWidth , height: CheckMarkIconWidth)
//
//
//        labelPaymentType.frame = CGRect(x: checkMarkIcon.frame.maxX + MarginLeftRight , y: 0, width: 120, height: bounds.height)
//
//        labelPalance.frame = CGRect(x: labelPaymentType.frame.maxX + MarginLeftRight / 2, y: 0, width:  bounds.width - (labelPaymentType.frame.maxX + RightArrowIconWidth + MarginLeftRight * 2) , height: bounds.height)
//        bottomLine.frame = CGRect(x: MarginLeftRight, y: bounds.height - 1, width: bounds.width - MarginLeftRight * 2 , height: 1)
//        rightArrowIcon.frame = CGRect(x: self.bounds.width - (RightArrowIconWidth + MarginLeftRight) , y:( bounds.height - 14) / 2, width: RightArrowIconWidth , height: 14)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
