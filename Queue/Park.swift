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
    let attractions: [Attraction]
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

enum ParkType: Int, CustomStringConvertible {
    case MagicKingdom = 80007944
    case Epcot = 80007838
    case HollywoodStudios = 80007998
    case AnimalKingdom = 80007823
    
    static let allValues = [.MagicKingdom, .Epcot, .HollywoodStudios, .AnimalKingdom] as [ParkType]
    
    var description: String {
        switch self {
        case .MagicKingdom:
            return "Magic Kingdom"
        case .Epcot:
            return "Epcot"
        case .HollywoodStudios:
            return "Hollywood Studios"
        case .AnimalKingdom:
            return "Animal Kingdom"
        }
    }
}