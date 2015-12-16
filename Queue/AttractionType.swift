//
//  AttractionType.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

enum AttractionType: String, RawRepresentable {
    case Attraction = "Attraction"
    case Entertainment = "Entertainment"
    
    static let allValues = [.Attraction, .Entertainment] as [AttractionType]
    
    init?(rawValue: String) {
        for type in AttractionType.allValues {
            if type.rawValue == rawValue {
                self = type
                return
            }
        }
        return nil
    }
}