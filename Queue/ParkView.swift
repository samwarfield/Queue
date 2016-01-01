//
//  ParkView.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit
import OAStackView

class ParkView: UIView {

    let backgroundImageView = UIImageView()
    let tintView = UIView()
    
    let stackView = OAStackView()
    let titleLabel = UILabel()
    let scheduleLabel = UILabel()
    
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
        
        stackView.axis = .Vertical
        stackView.alignment = .Center
        stackView.spacing = -2
        addSubview(stackView)
        NSLayoutConstraint.activateConstraints(stackView.constraintsWithAttributes([.CenterX, .CenterY], .Equal, to: self))
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        
        stackView.addArrangedSubview(scheduleLabel)
        scheduleLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.975)
        scheduleLabel.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        scheduleLabel.hidden = true
        
        backgroundImageView.addSubview(tintView)
        NSLayoutConstraint.activateConstraints(tintView.constraintsEqualToSuperview())
    }
}
