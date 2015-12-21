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

extension Park: Hashable {
    var hashValue: Int {
        return type.rawValue
    }
}

extension Park: Equatable {}
func ==(lhs: Park, rhs: Park) -> Bool {
    return lhs.hashValue == rhs.hashValue
}