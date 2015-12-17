//
//  ParkType.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

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
    
    var color: UIColor {
        switch self {
        case .MagicKingdom:
            return UIColor(red: 231.0/255.0, green: 49.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        case .Epcot:
            return UIColor(red: 122.0/255.0, green: 82.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        case .HollywoodStudios:
            return UIColor(red: 244.0/255.0, green: 156.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case .AnimalKingdom:
            return UIColor(red: 114.0/255.0, green: 189.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        }
    }
}