//
//  Attraction.swift
//  Queue
//
//  Created by Adam Binsz on 12/15/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

struct Attraction: RawRepresentable, Hashable, CustomStringConvertible {
    
    let name: String
    let identifier: Int
    let waitTime: Int?
    let status: String
    
    let rawValue: [String: AnyObject]
    
    init?(rawValue: [String: AnyObject]) {
        self.rawValue = [:]
        
        guard let name = rawValue["name"] as? String,
            waitTime = rawValue["waitTime"]?["postedWaitMinutes"] as? Int,
            id = (rawValue["id"] as? String)?.componentsSeparatedByString(";").first,
            identifier = Int(id) else {
            return nil
        }
        
        self.name = name
        self.identifier = identifier
        
        self.waitTime = waitTime
        self.status = ""
    }
    
    var hashValue: Int {
        return identifier
    }
    
    var description: String {
        return "[\n name: \(name)\n identifier: \(identifier)\n " + (waitTime == nil ? "" : "waitTime: \(waitTime!)\n ") + "status: \(status)\n]"
    }
}

extension Attraction: Equatable {}
func ==(lhs: Attraction, rhs: Attraction) -> Bool {
    return lhs.identifier == rhs.identifier
}