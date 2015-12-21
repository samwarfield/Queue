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

class ParkViewController: UITableViewController {
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
    
    private let parkType: ParkType
    private let parksManager: ParksManager
    
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
                let hasWaitTime = $0.waitTime != nil
                let isClosed = $0.status == "Closed"
                return $0.type == .Attraction && (hasWaitTime || isClosed)
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
                self.setToolbarLabelText("Updated at " + ParkViewController.dateFormatter.stringFromDate(park.lastUpdated))
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
        
        navigationController?.navigationBar.barTintColor = parkType.color
        navigationController?.toolbar.barTintColor = parkType.color
        navigationController?.toolbar.translucent = false
        
        navigationController?.view.backgroundColor = UIColor.whiteColor()
        
        tableView.backgroundColor = parkType.color.colorWithAlphaComponent(transparency)
        tableView.indicatorStyle = .White
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshAttractions:", forControlEvents: .ValueChanged)
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.tintColorDidChange()
        
        tableView.registerNib(UINib(nibName: "AttractionCell", bundle: nil), forCellReuseIdentifier: AttractionCellIdentifier)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        
        let toolbarButton = UIBarButtonItem(customView: toolbarLabel)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        setToolbarItems([flexibleButton, toolbarButton, flexibleButton], animated: true)
        
        if let park = parksManager.parks[parkType] where park.lastUpdated.timeIntervalSinceNow < 5 * 60 {
            self.park = park
        } else {
            refreshAttractions()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func refreshAttractions(sender: UIRefreshControl? = nil) {
        setToolbarLabelText("Refreshing…")
        self.startRefreshControl()
        parksManager.fetchAttractionsFor(parkType) { park, error in
            guard let park = park else { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.park = park
                self.stopRefreshControl()
            }
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return park?.attractions.count ?? 0
    }
    
    func setToolbarLabelText(text: String) {
        toolbarLabel.text = text
        toolbarLabel.sizeToFit()
    }
    
    func startRefreshControl() {
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.tintColorDidChange()
        
        self.refreshControl?.performSelector("beginRefreshing", withObject: nil, afterDelay: 0.0)
        
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.tintColorDidChange()
    }
    
    func stopRefreshControl() {
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.tintColorDidChange()
        
        self.refreshControl?.performSelector("endRefreshing", withObject: nil, afterDelay: 0.0)
        
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.tintColorDidChange()
    }
}