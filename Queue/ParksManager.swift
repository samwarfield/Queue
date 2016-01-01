//
//  ParksManager.swift
//  Queue
//
//  Created by Adam Binsz on 12/15/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

typealias ParkFetchCompletionHandler = (park: Park?, error: ErrorType?) -> ()

enum ParksManagerError: ErrorType {
    case URLError
    case SerializationError
}

class ParksManager {

    private(set) var parks = [ParkType: Park]()
    
    func fetchAttractionsFor(parkType: ParkType, completion: ParkFetchCompletionHandler? = nil) {
        let URLString = "https://api.wdpro.disney.go.com/facility-service/theme-parks/\(parkType.rawValue);entityType=theme-park/wait-times"
        guard let URL = NSURL(string: URLString) else {
            completion?(park: nil, error: ParksManagerError.URLError)
            return
        }
        
        QueueAPI.sendRequestWithURL(URL) { responseData, URLResponse, error in
            var completionError: ErrorType? = error
            var completionPark: Park?
            
            defer {
                if let error = completionError {
                    print(error)
                }
                
                print(parkType)
                
                completion?(park: completionPark, error: completionError)
            }
            
            guard let responseData = responseData else { return }
            
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
                
                guard let entries = response["entries"] as? [[String: AnyObject]] else {
                    completionError = ParksManagerError.SerializationError
                    return
                }
                
                let attractions = entries.map { Attraction(rawValue: $0) }.flatMap{$0}
                completionPark = Park(type: parkType, attractions: attractions, lastUpdated: NSDate())
                self.parks[parkType] = completionPark
                
            } catch {
                completionError = ParksManagerError.SerializationError
            }
        }
    }
}