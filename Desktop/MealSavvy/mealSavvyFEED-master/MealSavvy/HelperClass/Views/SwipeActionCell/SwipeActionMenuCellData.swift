//
//  SwipeActionMenuCellData.swift
//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

import Foundation
import UIKit
open class SwipeActionMenuCellData: NSObject {
    
    var text: String
    var subText: String = ""
    var icon: UIImage?
    var backgroundColor: UIColor
    var textColor: UIColor
    var action: (() -> Void)?
    var defaultAction: Bool
    var type : Int = 0
    public init(text: String = "", icon: UIImage? = nil, backgroundColor: UIColor = UIColor.gray, textColor: UIColor = UIColor.white,subText: String = "", defaultAction: Bool = false, action: (() -> Void)? = nil, type : Int = 0) {
        self.text = text
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.action = action
        self.defaultAction = defaultAction
        self.type = type
        self.subText = subText
    }
}
