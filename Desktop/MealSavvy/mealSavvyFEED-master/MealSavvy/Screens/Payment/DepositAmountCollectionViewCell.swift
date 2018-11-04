//
//  DepositAmountCollectionViewCell.swift
//  TOOLOW
//
//  Created by Sang Nguyen on 2/06/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

import Foundation
open class DepositAmountCollectionViewCell : UICollectionViewCell {
    var label = UILabel()
    private final let MarginLeftRight : CGFloat = 10
    private final let MarginTopBottom : CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.toolowSmokeBG()
        label.textColor = UIColor.toolowGreen()
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1;
        label.layer.borderColor = UIColor.toolowGreen().cgColor
        label.font = MBUtils.getUITextFontSize(15)
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        contentView.addSubview(label)
       
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: MarginLeftRight, y: MarginTopBottom, width: bounds.width - MarginLeftRight * 2, height: bounds.height - MarginTopBottom * 2)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func disableItem(isDisable: Bool){
        if isDisable {
            label.textColor = UIColor.toolowGray()
            label.layer.borderColor = UIColor.toolowGray().cgColor
        } else {
            label.textColor = UIColor.toolowGreen()
            label.layer.borderColor = UIColor.toolowGreen().cgColor
        }
        
    }
}
