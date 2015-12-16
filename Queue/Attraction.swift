//
//  Attraction.swift
//  Queue
//
//  Created by Adam Binsz on 12/15/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

struct Attraction: RawRepresentable {
    
    let name: String
    let identifier: Int
    let waitTime: Int?
    let status: String
    
    let rawValue: [String: AnyObject]
    
    init?(rawValue: [String: AnyObject]) {
        self.rawValue = rawValue
        
        guard let name = rawValue["name"] as? String,
            waitTimeInfo = rawValue["waitTime"] as? [String: AnyObject],
            status = waitTimeInfo["status"] as? String,
            id = (rawValue["id"] as? String)?.componentsSeparatedByString(";").first,
            identifier = Int(id)
            else {
                print("Attraction failed verification: \(rawValue)")
                return nil
        }
        
        self.name = name
        self.identifier = identifier
        
        self.waitTime = waitTimeInfo["postedWaitMinutes"] as? Int
        self.status = status
    }
}

extension Attraction: CustomStringConvertible {
    var description: String {
        return "\(name): \(status)" + (waitTime == nil ? "" : ", \(waitTime) minutes")
    }
}

extension Attraction: CustomDebugStringConvertible {
    var debugDescription: String {
        return "[\n name: \(name)\n identifier: \(identifier)\n " + (waitTime == nil ? "" : "waitTime: \(waitTime!)\n ") + "status: \(status)\n]"
    }
}

extension Attraction: Hashable {
    var hashValue: Int {
        return identifier
    }
}

extension Attraction: Equatable {}
func ==(lhs: Attraction, rhs: Attraction) -> Bool {
    return lhs.identifier == rhs.identifier
}