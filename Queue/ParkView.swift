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
        
        backgroundImageView.contentMode = .ScaleAspectFill
        addSubview(backgroundImageView)
        NSLayoutConstraint.activateConstraints(backgroundImageView.constraintsEqualToSuperview())
        
        addSubview(titleLabel)
        NSLayoutConstraint.activateConstraints(titleLabel.constraintsWithAttributes([.CenterX, .CenterY], .Equal, to: self))
        NSLayoutConstraint.activateConstraints(titleLabel.constraintsWithAttributes([.Width, .Height], .LessThanOrEqual, to: self))
        
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        
        backgroundImageView.addSubview(tintView)
        NSLayoutConstraint.activateConstraints(tintView.constraintsEqualToSuperview())
    }
}
