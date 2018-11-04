//
//  CustomerStatusTitleCell.swift
//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

import Foundation
import UIKit


open class ManagePaymentCollectionViewCell : UICollectionViewCell{
    open let imageViewRightArrow = UIImageView()
    let viewContent = UIView()
    open let labelLeft = UILabel()
    open let labelRight = UILabel()
    
    fileprivate final let RightArrowWidth : CGFloat = 8
    fileprivate final let RightArrowHeight : CGFloat = 14
    fileprivate final let MarginLeftRight : CGFloat = 10
    fileprivate final let MarginTopBottom : CGFloat = 5
    fileprivate final let TextMarginLeft : CGFloat = 15
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.toolowSmokeBG()
       
        self.labelLeft.textColor = UIColor.toolowDarkText()
        self.labelLeft.font = MBUtils.getToolowFontSize(15)
        self.viewContent.addSubview(labelLeft)
        
        self.labelRight.textColor = UIColor.toolowGreen()
        self.labelRight.font = MBUtils.getToolowFontSize(15)
        self.labelRight.textAlignment = .right
        self.viewContent.addSubview(labelRight)
        
        self.imageViewRightArrow.image = UIImage(named: "right-gray-arrow-16x28")
        self.viewContent.addSubview(imageViewRightArrow)
        self.addSubview(self.viewContent)
        self.viewContent.layer.borderColor = UIColor.secondary1().cgColor
        self.viewContent.layer.borderWidth = 1.0
        self.viewContent.backgroundColor = UIColor.white
    }

    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.viewContent.frame = CGRect(x: MarginLeftRight, y: MarginTopBottom , width: bounds.width - MarginLeftRight * 2, height: bounds.height - MarginTopBottom * 2)
        self.viewContent.layer.cornerRadius = 5
        self.labelLeft.frame = CGRect(x: TextMarginLeft, y: 0, width: (self.viewContent.frame.width - (TextMarginLeft * 2 + RightArrowWidth)) / 2, height: self.viewContent.frame.height)
        self.labelRight.frame = CGRect(x: labelLeft.frame.maxX, y: 0, width: (self.viewContent.frame.width - (TextMarginLeft * 3 + RightArrowWidth)) / 2, height: self.viewContent.frame.height)
        self.imageViewRightArrow.frame = CGRect(x: labelRight.frame.maxX + TextMarginLeft, y: (self.viewContent.frame.height - RightArrowHeight) / 2 , width: RightArrowWidth, height: RightArrowHeight)
        
       
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
