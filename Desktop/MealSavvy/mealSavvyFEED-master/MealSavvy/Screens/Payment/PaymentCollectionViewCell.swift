//
//  PaymentCollectionViewCell.swift
//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

import Foundation
import UIKit

open class PaymentCollectionViewCell : SwipeActionMenuCell{
    open var cardIcon = UIImageView()
    open var checkMarkIcon = UIImageView()
    open var rightArrowIcon = UIImageView()
    open var labelName = UILabel()
    open var labelPaymentType = UILabel()
    open var bottomLine = UIView()
    fileprivate final let LabelWidth : CGFloat = 100
    fileprivate final let CardWidth : CGFloat = 50
    fileprivate final let MarginLeftRight : CGFloat = 10
    fileprivate final let CheckMarkIconWidth : CGFloat = 20
    fileprivate final let RightArrowIconWidth : CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        checkMarkIcon.image = UIImage(named: "icon-check-mark")
        cardIcon.image = UIImage(named: "visa")
        labelName.textAlignment = .right
        self.labelPaymentType.textColor = UIColor.darkGray
        self.labelPaymentType.font = MBUtils.getCommonFont()
        rightArrowIcon.image = UIImage(named: "right-arrow-gray-16x28")
        self.contentView.addSubview(checkMarkIcon)
        self.contentView.addSubview(cardIcon)
        self.labelPaymentType.textColor = UIColor.gray
        self.labelPaymentType.font = MBUtils.getCommonFont()
        self.contentView.addSubview(labelPaymentType)
        self.contentView.addSubview(labelName)
        self.contentView.addSubview(rightArrowIcon)
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.isHidden = true
        self.addSubview(bottomLine)
        layoutSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        checkMarkIcon.frame = CGRect(x: MarginLeftRight , y: 5, width: CheckMarkIconWidth , height: CheckMarkIconWidth)
        
        cardIcon.frame = CGRect(x: checkMarkIcon.frame.maxX + MarginLeftRight, y: (bounds.height - 31) / 2, width: CardWidth, height: 31)
        
        labelPaymentType.frame = CGRect(x: cardIcon.frame.maxX + MarginLeftRight , y: 0, width: 70, height: bounds.height)
        
        labelName.frame = CGRect(x: labelPaymentType.frame.maxX + MarginLeftRight / 2, y: 0, width:  bounds.width - (labelPaymentType.frame.maxX + RightArrowIconWidth + MarginLeftRight * 2) , height: bounds.height)
        bottomLine.frame = CGRect(x: MarginLeftRight, y: bounds.height - 1, width: bounds.width - MarginLeftRight * 2 , height: 1)
        rightArrowIcon.frame = CGRect(x: self.bounds.width - (RightArrowIconWidth + MarginLeftRight) , y:( bounds.height - 14) / 2, width: RightArrowIconWidth , height: 14)
    }
    
    
}

