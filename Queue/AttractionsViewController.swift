//
//  ParkViewController.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

let AttractionCellIdentifier = "AttractionCell"

let transparency: CGFloat = 0.95

class AttractionsViewController: UITableViewController {
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
    
    private let parkType: ParkType
    private let parksManager: ParksManager
    
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    private let toolbarLabel: UILabel = {
        let toolbarLabel = UILabel()
        toolbarLabel.text = "Refreshing…"
        toolbarLabel.textColor = UIColor.whiteColor()
        toolbarLabel.font = UIFont.systemFontOfSize(11)
        toolbarLabel.sizeToFit()
        return toolbarLabel
    }()
    
    private var park: Park? {
        didSet {
            guard var park = park else { return }
            park.attractions = park.attractions.filter{
                if $0.type != .Attraction { return false }
                if $0.fastPassAvailable { return true }
                
                let hasWaitTime = $0.waitTime != nil
                let isClosed = /* $0.status == "Closed" || */ $0.status == "Down"
                
                return hasWaitTime || isClosed
            }.sort {
                if $0.waitTime != nil && $1.waitTime != nil {
                    return $0.waitTime < $1.waitTime
                }
                
                if $0.waitTime == nil && $1.waitTime == nil {
                    return $0.status < $1.status
                }
                
                return $0.waitTime != nil
            }
            
            self.park = park
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.setToolbarLabelText("Updated at " + AttractionsViewController.dateFormatter.stringFromDate(park.lastUpdated))
            }
        }
    }

    init(parkType: ParkType, parksManager: ParksManager) {
        self.parkType = parkType
        self.parksManager = parksManager
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.title = parkType.description
        
        navigationController?.view.backgroundColor = UIColor.whiteColor()
        
        tableView.backgroundColor = parkType.color.colorWithAlphaComponent(transparency)
        tableView.indicatorStyle = .White
        tableView.registerNib(UINib(nibName: "AttractionCell", bundle: nil), forCellReuseIdentifier: AttractionCellIdentifier)
        tableView.estimatedRowHeight = 58
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshAttractions:", forControlEvents: .ValueChanged)
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.tintColorDidChange()
        
        let toolbarButton = UIBarButtonItem(customView: toolbarLabel)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        setToolbarItems([flexibleButton, toolbarButton, flexibleButton], animated: true)
        
        if let park = parksManager.parks[parkType] where abs(park.lastUpdated.timeIntervalSinceNow) < 5 * 60 {
            self.park = park
        } else {
            refreshAttractions()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = parkType.color
        navigationController?.toolbar.barTintColor = parkType.color
        navigationController?.toolbar.translucent = false
    }
    
    func refreshAttractions(sender: UIRefreshControl? = nil) {
        setToolbarLabelText("Refreshing…")
        parksManager.fetchAttractionsFor(parkType) { park, error in
            guard let park = park else { return }
            self.park = park
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AttractionCellIdentifier, forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.clearColor()
        
        guard let attractionCell = cell as? AttractionCell, park = park else { return cell }
        let attraction = park.attractions[indexPath.row]
        
        attractionCell.titleLabel.text = attraction.name
        attractionCell.detailLabel.text = attraction.waitTime == nil ? attraction.status : "\(attraction.waitTime!)"
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = park?.attractions.count ?? 0
        setActivityIndicatorViewHidden(numberOfRows != 0)
        self.tableView.scrollEnabled = numberOfRows != 0
        return numberOfRows
    }
    
    private func setToolbarLabelText(text: String) {
        toolbarLabel.text = text
        toolbarLabel.sizeToFit()
    }
    
    private func setActivityIndicatorViewHidden(hidden: Bool) {
        if hidden {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            return
        }
        
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activateConstraints(activityIndicatorView.constraintsWithAttributes([.CenterX, .CenterY], .Equal, to: view))
    }
}