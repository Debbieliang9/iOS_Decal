

import Foundation
import UIKit
open class SwipeMenuOptionView: UIView {
    
    fileprivate var type : Int = 0
    fileprivate(set) var iconView = { () -> UIImageView in
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    } ()
    fileprivate(set) lazy var titleLabel =  { () -> UILabel in
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    } ()
    fileprivate(set) lazy var timeLabel =  { () -> UILabel in
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        return label
    } ()
    fileprivate lazy var triggerButton =  { () -> UIButton in
        let button = UIButton(type: .custom)
        return button
    } ()
    fileprivate var container = UIView()
    
    var position = MenuOptionPosition.right
    var optionWidth = CGFloat(0)
    var data: SwipeActionMenuCellData? {
        didSet {
            if let data = self.data {
                self.iconView.image = data.icon
                self.titleLabel.text = data.text
                self.timeLabel.text = data.subText
                self.backgroundColor = data.backgroundColor
                self.titleLabel.textColor = data.textColor
                self.type = data.type
            }
        }
    }
    
    var actionHander: (() -> Void)?
    
    init(frame: CGRect, position: MenuOptionPosition) {
        super.init(frame: frame)
        self.position = position
        self.backgroundColor = UIColor.gray
        self.triggerButton.addTarget(self, action: #selector(self.fireAction), for: .touchUpInside)
        self.container.addSubview(self.triggerButton)
        self.container.addSubview(self.iconView)
        self.container.addSubview(self.titleLabel)
        self.container.addSubview(self.timeLabel)
        self.addSubview(self.container)
    }

    @objc func fireAction() {
        if let data = self.data, let action = data.action {
            action()
//            if let actionHandler = self.actionHander {
//                actionHandler()
//            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        let widthHeightRatio = CGFloat(9.0 / 13.0)
        let frame = self.bounds
        let height = frame.size.height
        let iconHeight = height * 0.7
        let labelHeight = height - iconHeight
        
        var imageIconSize = CGSize(width: 40, height: 40)
        if type == 1 {
            imageIconSize = CGSize(width: 52, height: 36)
        }
        if self.optionWidth == 0 {
           self.optionWidth = CGFloat(height * widthHeightRatio)
        }
        
        var xPos = CGFloat(0)
        
        if self.position == .left {
            xPos = frame.size.width - self.optionWidth
        }
        self.container.frame = CGRect(x: xPos, y: 0, width: self.optionWidth, height: height)
        self.triggerButton.frame = self.container.bounds
        
        let iconXPos = (self.optionWidth - imageIconSize.width) / 2.0
        let iconYPos = (iconHeight - imageIconSize.height) / 2.0
        switch type {
        case 1:
            self.iconView.frame = CGRect(x: iconXPos, y: (frame.height - imageIconSize.height ) / 2, width: imageIconSize.width, height: imageIconSize.height)
            self.titleLabel.frame = CGRect(x: -(optionWidth / 3 + 5),y: (frame.size.height - labelHeight) / 2, width: self.optionWidth, height: labelHeight)
            self.titleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI)/2);
            self.titleLabel.font = UIFont.systemFont(ofSize: 11)
            break
        case 2:
            self.iconView.frame = CGRect(x: iconXPos + 15, y: (frame.height - imageIconSize.height ) / 2, width: 20, height: 20)
            self.timeLabel.frame = CGRect(x: iconXPos + 15, y: (frame.height - imageIconSize.height ) / 2 + 20, width: 30, height: 25)
            self.titleLabel.frame = CGRect(x: -(50 / 3 ),y: (frame.size.height - labelHeight) / 2, width: 50, height: labelHeight)
            self.titleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI)/2);
            self.titleLabel.font = UIFont.systemFont(ofSize: 8)
            self.titleLabel.numberOfLines = 2
            break
        default:
            self.iconView.frame = CGRect(x: iconXPos, y: iconYPos, width: imageIconSize.width, height: imageIconSize.height)
            self.titleLabel.frame = CGRect(x: 0,y: iconHeight, width: self.optionWidth, height: labelHeight)
            break
        } 
       
    }
    
}
