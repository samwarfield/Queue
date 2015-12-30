//
//  Schedule.swift
//  Queue
//
//  Created by Adam Binsz on 12/23/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation
import SwiftDate

struct Schedule: RawRepresentable, Hashable{
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static let timeFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter
    }()
    
    let date: NSDate
    let openingTime: NSDate
    let closingTime: NSDate
    let type: ScheduleType
    
    let rawValue: [String: AnyObject]
    
    var hashValue: Int {
        get {
            return date.hashValue
        }
    }
    
    init?(rawValue: [String: AnyObject]) {
        guard let dateString = rawValue["date"] as? String,
            startTime = rawValue["startTime"] as? String,
            endTime = rawValue["endTime"] as? String,
            timeZone = rawValue["timeZone"] as? String,
            typeString = rawValue["type"] as? String,
            type = ScheduleType(rawValue: typeString)
        else { return nil }
        
        guard let date = Schedule.dateFormatter.dateFromString(dateString),
            openingTime = Schedule.timeFormatter.dateFromString(dateString + " " + startTime + " " + timeZone),
            var closingTime = Schedule.timeFormatter.dateFromString(dateString + " " + endTime + " " + timeZone)
            else { return nil }
        
        if closingTime.timeIntervalSinceDate(openingTime) <= 0 {
            closingTime += 1.day
        }
        
        self.rawValue = rawValue
        self.date = date
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.type = type
    }
}

extension Schedule: Equatable { }
func ==(lhs: Schedule, rhs: Schedule) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

enum ScheduleType: String {
    case Operating = "Operating"
    case EMH = "Extra Magic Hours"
}