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
    let type: AttractionType
    let identifier: Int
    let waitTime: Int?
    let status: String
    let fastPassAvailable: Bool
    
    let rawValue: [String: AnyObject]
    
    init?(rawValue: [String: AnyObject]) {
        self.rawValue = rawValue
        
        guard let name = rawValue["name"] as? String,
            typeString = rawValue["type"] as? String,
            type = AttractionType(rawValue: typeString),
            waitTimeInfo = rawValue["waitTime"] as? [String: AnyObject],
            status = waitTimeInfo["status"] as? String,
            id = (rawValue["id"] as? String)?.componentsSeparatedByString(";").first,
            identifier = Int(id)
            else {
                print("Attraction failed verification: \(rawValue)")
                return nil
        }
        
        self.name = name
        self.type = type
        self.identifier = identifier
        
        self.waitTime = waitTimeInfo["postedWaitMinutes"] as? Int
        self.status = status
        
        self.fastPassAvailable = Bool((waitTimeInfo["fastPass"]?["available"] as? Bool) ?? 0)
    }
}

extension Attraction: CustomStringConvertible {
    var description: String {
        return "\(name): " + (waitTime == nil ? "\(status)" : "\(waitTime!) minutes")
    }
}

extension Attraction: CustomDebugStringConvertible {
    var debugDescription: String {
        return "[\n name: \(name)\n type: \(type)\n identifier: \(identifier)\n " + (waitTime == nil ? "" : "waitTime: \(waitTime!)\n ") + "status: \(status)\n]"
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