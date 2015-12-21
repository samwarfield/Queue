//
//  ParkWaitTimes.swift
//  Queue
//
//  Created by Adam Binsz on 12/15/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

struct Park {
    let type: ParkType
    var attractions: [Attraction]
    let lastUpdated: NSDate
}