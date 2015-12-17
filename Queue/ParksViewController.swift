//
//  ParksViewController.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

class ParksViewController: UINavigationController {

    let parksManager = ParksManager()
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .FillEqually
        view.addSubview(stackView)
        NSLayoutConstraint.activateConstraints(stackView.constraintsEqualToSuperview())
        
        for parkType in ParkType.allValues {
            let parkView = ParkView()
            parkView.titleLabel.text = parkType.description
            parkView.backgroundColor = parkType.color
            parkView.tag = parkType.rawValue
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "parkViewTapped:")
            parkView.addGestureRecognizer(gestureRecognizer)
            
            stackView.addArrangedSubview(parkView)
        }
        
        parksManager.fetchAttractionsFor(.MagicKingdom) { park, error in
            
            let rawValues = park?.attractions.map{$0.rawValue}
            print(rawValues)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func parkViewTapped(sender: UITapGestureRecognizer) {
        guard let view = sender.view, parkType = ParkType(rawValue: view.tag) else { return }
        
    }
}

