//
//  MenuCollectionViewCell.swift
//  TooLow
//
//  Created by Sang Nguyen on 2/12/17.
//  Copyright © 2017 TOOLOW. All rights reserved.
//

import UIKit

open class MenuCollectionViewCell: UICollectionViewCell {
    open var labelItemName = UILabel()
    open var viewLine = UIView()
    private final let MarginLeftRight : CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        self.labelItemName.textColor = UIColor.toolowGreen()
        self.labelItemName.font = MBUtils.getUITextFontSize(15)
        self.labelItemName.lineBreakMode = .byTruncatingTail
        self.addSubview(labelItemName)
        self.viewLine.backgroundColor = UIColor.secondary1()
        self.addSubview(viewLine)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.labelItemName.frame =  CGRect(x: MarginLeftRight , y: 0, width: self.bounds.width - MarginLeftRight * 2 , height: self.bounds.height)
        self.viewLine.frame =  CGRect(x: MarginLeftRight , y: self.bounds.height - 1, width: self.bounds.width - MarginLeftRight * 2 , height: 0.5)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
