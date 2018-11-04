//
//  CashOutMethodCollectionViewCell.swift
//  TOOLOW
//
//  Created by Sang Nguyen on 2/06/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

import Foundation
import UIKit

open class CashOutMethodCollectionViewCell : SwipeActionMenuCell{
    open var checkMarkIcon = UIImageView()
    open var labelName = UILabel()
    open var labelFee = UILabel()
    open var bottomLine = UIView()
    fileprivate final let LabelFeeWith : CGFloat = 50
    fileprivate final let MarginLeftRight : CGFloat = 10
    fileprivate final let CheckMarkIconWidth : CGFloat = 13
    fileprivate final let CheckMarkIconHeight : CGFloat = 10
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        checkMarkIcon.image = UIImage(named: "check-mark-26x20")
        self.contentView.addSubview(checkMarkIcon)
        self.labelName.textColor = UIColor.toolowDarkText()
        self.labelName.font = MBUtils.getToolowFontSize(15)
        self.labelName.lineBreakMode = .byTruncatingMiddle
        self.labelName.minimumScaleFactor = 0.7;
        
        self.contentView.addSubview(labelName)
        self.labelFee.textColor = UIColor.toolowOrange()
        self.labelFee.font = MBUtils.getToolowFontSize(15)
        self.labelFee.textAlignment = .right
        self.contentView.addSubview(labelFee)
        
        bottomLine.backgroundColor = UIColor.secondary1()
        bottomLine.isHidden = true
        self.addSubview(bottomLine)
        layoutSubviews()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        checkMarkIcon.frame = CGRect(x: MarginLeftRight , y: (self.bounds.height - CheckMarkIconHeight ) / 2, width: CheckMarkIconWidth , height: CheckMarkIconHeight)
        labelName.frame = CGRect(x: checkMarkIcon.frame.maxX + MarginLeftRight, y: 0, width:  bounds.width - (checkMarkIcon.frame.maxX + LabelFeeWith + MarginLeftRight * 2) , height: bounds.height)
        labelFee.frame = CGRect(x: labelName.frame.maxX, y: 0, width: LabelFeeWith, height: bounds.height)
        bottomLine.frame = CGRect(x: MarginLeftRight, y: bounds.height - 1, width: bounds.width - MarginLeftRight * 2 , height: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

