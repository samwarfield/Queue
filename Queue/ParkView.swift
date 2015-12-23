//
//  ParkView.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

class ParkView: UIView {
    
    let titleLabel = UILabel()
    let backgroundImageView = UIImageView()
    let tintView = UIView()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    private func layoutView() {
        clipsToBounds = true
        
        #if os(tvOS) 
            backgroundImageView.adjustsImageWhenAncestorFocused = true
        #endif
        
        backgroundImageView.contentMode = .ScaleAspectFill
        addSubview(backgroundImageView)
        NSLayoutConstraint.activateConstraints(backgroundImageView.constraintsEqualToSuperview())
        
        tintView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(tintView)
        NSLayoutConstraint.activateConstraints(tintView.constraintsWithAttributes([.Leading, .Trailing, .Top, .Bottom], .Equal, to: backgroundImageView))
        
        addSubview(titleLabel)
        NSLayoutConstraint.activateConstraints(titleLabel.constraintsWithAttributes([.CenterX, .CenterY], .Equal, to: self))
        NSLayoutConstraint.activateConstraints(titleLabel.constraintsWithAttributes([.Width, .Height], .LessThanOrEqual, to: self))
        
        var fontSize: CGFloat = 28.0
        if #available(iOS 9, *) {
            fontSize = UIDevice.currentDevice().userInterfaceIdiom == .TV ? 64 : fontSize
        }
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: fontSize)
        titleLabel.textColor = UIColor.whiteColor()
    }
}

extension ParkView {
    override func canBecomeFocused() -> Bool {
        return true
    }
    
    @available(iOS 9.0, *)
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        backgroundImageView.bringSubviewToFront(tintView)
    }
}
