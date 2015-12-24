//
//  ParksViewController.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

class ParksViewController: UIViewController {

    let parksManager = ParksManager()
    
    var parkViews = [ParkView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        if #available(iOS 9.0, *) {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
        
        
        for parkType in ParkType.allValues {
            let parkView = ParkView()
            let image = UIImage(named: parkType.description)!.tintWithColor(parkType.color.colorWithAlphaComponent(0.5))
            parkView.backgroundImageView.image = image
            parkView.titleLabel.text = parkType.description
            parkView.tag = parkType.rawValue
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "parkViewTapped:")
            parkView.addGestureRecognizer(gestureRecognizer)
            
            view.addSubview(parkView)
            NSLayoutConstraint.activateConstraints(parkView.constraintsWithAttributes([.Leading, .Trailing], .Equal, to: view))
            
            if let last = parkViews.last {
                parkView.constraintWithAttribute(.Top, .Equal, to: .Bottom, of: last).active = true
                parkView.constraintWithAttribute(.Height, .Equal, to: .Height, of: last).active = true
            } else {
                parkView.constraintWithAttribute(.Top, .Equal, to: .Top, of: view).active = true
            }
            
            parkViews.append(parkView)
            
            if parkViews.count == ParkType.allValues.count {
                parkView.constraintWithAttribute(.Bottom, .Equal, to: .Bottom, of: view).active = true
            }
        }
        
        for parkType in ParkType.allValues {
            parksManager.fetchAttractionsFor(parkType)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    func parkViewTapped(sender: UITapGestureRecognizer) {
        guard let view = sender.view, parkType = ParkType(rawValue: view.tag) else { return }
        let parkViewController = AttractionsViewController(parkType: parkType, parksManager: parksManager)
        navigationController?.pushViewController(parkViewController, animated: true)
    }
}

@available(iOS 9, *)
extension ParksViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        for parkView in parkViews {
            if CGRectContainsPoint(parkView.frame, location) {
                guard let parkType = ParkType(rawValue: parkView.tag) else { continue }
                return AttractionsViewController(parkType: parkType, parksManager: parksManager)
            }
        }
        
        return nil
    }
}
