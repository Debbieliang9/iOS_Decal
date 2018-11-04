

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

enum MenuOptionPosition: Int {
    case left
    case right
}

open class SwipeActionMenuCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    open var defaultLeftData: SwipeActionMenuCellData?
    open var defaultRightData: SwipeActionMenuCellData?
    
    open var leftMenuItems: [SwipeActionMenuCellData]?
    {
        didSet {
            self.removeFromSuperview(self.leftViewPool)
            self.leftViewPool = nil
        }
    }
    
    open var rightMenuItems: [SwipeActionMenuCellData]?
    {
        didSet {
            self.removeFromSuperview(self.rightViewPool)
            self.rightViewPool = nil
        }
    }
    
    open var isShowLeftMenu : Bool = false
    open var leftViewPool: [SwipeMenuOptionView]?
    open var rightViewPool: [SwipeMenuOptionView]?
    open var menuItems: [SwipeActionMenuCellData]?
    {
        didSet {
            self.removeFromSuperview(self.rightViewPool)
            self.rightViewPool = nil
        }
    }

    fileprivate lazy var panRecognizer: UIPanGestureRecognizer = {
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        recognizer.delegate = self
        return recognizer
        
    } ()
    
    open var optionWidth = CGFloat(88)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.white
        self.addGestureRecognizer(self.panRecognizer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SwipeActionMenuCell.swipeActionMenuCellDismissNotification(_:)),
            name: NSNotification.Name(rawValue: "SwipeActionMenuCellDismissNotification"),
            object: nil
        )
    }
    
    @objc func swipeActionMenuCellDismissNotification(_ notification: Notification) {
        if let object = notification.object , !(object is SwipeActionMenuCell) {
            self.dismissMenu()
        }
    }
    
    func removeFromSuperview(_ viewPool: [SwipeMenuOptionView]?) {
        if let pool = viewPool {
            for v in pool {
                v.removeFromSuperview()
            }
        }
    }
    
    func prepareAtionMenu() {
        
        let size = self.bounds.size
        
        let prepareOptionView = { (menuItems: [SwipeActionMenuCellData], position: MenuOptionPosition) -> [SwipeMenuOptionView] in
            var viewPool = [SwipeMenuOptionView]()
            for item in menuItems {
                
                var xPos = size.width
                
                if position == .left {
                    
                    xPos = -size.width
                    if item.defaultAction {
                        self.defaultLeftData = item
                    }
                    
                } else {
                    
                    if item.defaultAction {
                        self.defaultRightData = item
                    }
                    
                }
                
                let option = SwipeMenuOptionView(frame: CGRect(x: xPos, y: 0, width: size.width, height: size.height), position: position)
                option.data = item
                option.optionWidth = self.optionWidth
                
                option.actionHander = {
                    self.dismissMenu()
                }
                
                viewPool.append(option)
                self.addSubview(option)
                
            }
            
            return viewPool
            
        }
        
        if let leftMenuItems = self.leftMenuItems
            , self.leftViewPool == nil && leftMenuItems.count > 0 {
                self.leftViewPool = prepareOptionView(leftMenuItems, .left)
        }
        
        if let menuItems = self.menuItems
            , self.rightViewPool == nil && menuItems.count > 0 {
                self.rightViewPool = prepareOptionView(menuItems, .right)
        }
        
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer === self.panRecognizer {
            let translation = self.panRecognizer.translation(in: self.superview)
            // Check for horizontal gesture
            if (fabsf(Float(translation.x)) > fabsf(Float(translation.y))) {
                return true
            }
            
            dismissMenu()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SwipeActionMenuCellDismissNotification"), object: self)
            
            return false
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    var originalCenter = CGPoint.zero
    var rightCompleteOnDragRelease = false
    var leftCompleteOnDragRelease = false
    var defaultRightActionCompleteOnDrag = false
    var defaultLeftActionCompleteOnDrag = false
    
    func layoutMenuViews(_ referenceView: UIView, viewPool: [SwipeMenuOptionView], position: MenuOptionPosition, animated: Bool = false) {
        
        let spacing = (self.bounds.size.width - referenceView.frame.maxX) / CGFloat(viewPool.count)
        for i in 0 ..< viewPool.count {
            let view = viewPool[i]
            var delta = spacing * CGFloat(i)
            if position == .left {
                
//                if self.defaultLeftActionCompleteOnDrag {
//                    delta = 0
//                }
                NSLog("delta %f", delta)
                UIView.animate(
                    withDuration: animated ? 0.2 : 0.0,
                    animations: { () -> Void in
                        view.frame = CGRect(x: referenceView.frame.minX - view.bounds.size.width + delta, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
                    }
                )
                
            } else {
                
                if self.defaultRightActionCompleteOnDrag {
                    delta = 0
                }
                
                UIView.animate(
                    withDuration: animated ? 0.2 : 0.0,
                    animations: { () -> Void in
                        view.frame = CGRect(x: referenceView.frame.maxX + delta, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
                    }
                )
                
            }
        }
        
    }
    
    func dismissMenu() {
        self.isShowLeftMenu = false;
        let referenceView = self.contentView
        referenceView.frame = CGRect(
            x: 0,
            y: referenceView.frame.origin.y,
            width: referenceView.bounds.size.width,
            height: referenceView.bounds.size.height
        )
        UIView.animate(
            withDuration: 0.2,
            animations: { () -> Void in
                if let viewPool = self.rightViewPool {
                    for view in viewPool {
                        let width = referenceView.bounds.size.width
                        view.frame = CGRect(x: width, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
                    }
                }
                
                if let viewPool = self.leftViewPool {
                    for view in viewPool {
                        view.frame = CGRect(x: -view.bounds.size.width, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
                    }
                }
                
            },
            completion: nil
        )
        
    }

    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let defaultActionPercentage = CGFloat(0.7)
        let referenceView = self.contentView
        
        if recognizer.state == .began {
            self.originalCenter = referenceView.center
            self.prepareAtionMenu()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SwipeActionMenuCellDismissNotification"), object: self)
        }
        
        if recognizer.state == .changed {
            
            var translation = recognizer.translation(in: self)
            NSLog("translation : %f %f", translation.x, referenceView.frame.origin.x)
            //Disable right menu if swipe to left
            if translation.x <= 0 && (self.menuItems == nil || self.menuItems?.count < 0) {
                if referenceView.frame.origin.x <= 0 {
                    translation.x = CGFloat(0)
                }
                
            }
            
            //Disable left menu if swipe to right
            if translation.x > 0 && (self.leftMenuItems == nil || self.leftMenuItems?.count < 0) {
                if referenceView.frame.origin.x >= 0 {
                    translation.x = CGFloat(0)
                }
            }
            
            referenceView.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            
            if let viewPool = self.leftViewPool {
                let delta = referenceView.frame.origin.x
                self.leftCompleteOnDragRelease = delta > ((self.optionWidth * CGFloat(viewPool.count))) / 2
                
                let defaultLeftCompleteOnDrag = delta > self.bounds.size.width * defaultActionPercentage
                let animated = defaultLeftCompleteOnDrag != self.defaultLeftActionCompleteOnDrag
                self.defaultLeftActionCompleteOnDrag = defaultLeftCompleteOnDrag
                
                self.layoutMenuViews(referenceView, viewPool: viewPool, position: .left, animated: animated)
            }
            
            if let viewPool = self.rightViewPool {
                let delta = self.bounds.size.width - referenceView.frame.maxX
                self.rightCompleteOnDragRelease = delta > (self.optionWidth * CGFloat(viewPool.count))
                
                let defaultRightCompleteOnDrag = delta > self.bounds.size.width * defaultActionPercentage
                let animated = defaultRightCompleteOnDrag != self.defaultRightActionCompleteOnDrag
                self.defaultRightActionCompleteOnDrag = defaultRightCompleteOnDrag
                
                self.layoutMenuViews(referenceView, viewPool: viewPool, position: .right, animated: animated)
            }

        }
        
        if recognizer.state == .ended {
            
            if self.defaultRightActionCompleteOnDrag {
                if let data = self.defaultRightData, let action = data.action {
                    action()
                }
                self.dismissMenu()
                
            } else if self.defaultLeftActionCompleteOnDrag {
                if let data = self.defaultLeftData, let action = data.action {
                    action()
                }
                self.dismissMenu()
                
            } else if self.rightCompleteOnDragRelease {
                
                UIView.animate(
                    withDuration: 0.2,
                    animations: { () -> Void in
                        if let viewPool = self.rightViewPool {
                            referenceView.frame = CGRect(x: -(self.optionWidth * CGFloat(viewPool.count)), y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height)
                            self.layoutMenuViews(referenceView, viewPool: viewPool, position: .right)
                        }
                    },
                    completion: { (success) in

                    }
                )
                
            } else if self.leftCompleteOnDragRelease {
                
                self.showLeftMenu(true)

            } else {
                
                self.dismissMenu()
                
            }
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    open func showLeftMenu(_ animation: Bool) {
        
        let referenceView = self.contentView
        if animation {
            UIView.animate(
                withDuration: 0.2,
                animations: { () -> Void in
                    if let viewPool = self.leftViewPool {
                        referenceView.frame = CGRect(x: self.optionWidth * CGFloat(viewPool.count), y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height)
                        self.layoutMenuViews(referenceView, viewPool: viewPool, position: .left)
                    }
                },
                completion: { (success) in
                }
            )
        } else {
            self.prepareAtionMenu()
            if let viewPool = self.leftViewPool {
                referenceView.frame = CGRect(x: self.optionWidth * CGFloat(viewPool.count), y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height)
                self.layoutMenuViews(referenceView, viewPool: viewPool, position: .left)
            }
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        if isShowLeftMenu {
            self.showLeftMenu(false)
        }
    }
}
