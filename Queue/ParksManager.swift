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
        if let token = TokenManager.token, expirationDate = TokenManager.expirationDate where expirationDate.timeIntervalSinceNow > 0 {
            fetchAttractionsFor(parkType, authorizationToken: token, completion: completion)
            return
        }
        
        TokenManager.fetchToken { token, error in
            guard let token = token else {
                completion?(park: nil, error: error)
                return
            }
            
            self.fetchAttractionsFor(parkType, authorizationToken: token, completion: completion)
        }
    }
    
    private func fetchAttractionsFor(parkType: ParkType, authorizationToken: String, completion: ParkFetchCompletionHandler?) {
        
        let URLString = "https://api.wdpro.disney.go.com/facility-service/theme-parks/\(parkType.rawValue);entityType=theme-park/wait-times"
        guard let URL = NSURL(string: URLString) else {
            completion?(park: nil, error: ParksManagerError.URLError)
            return
        }
        
        requestWithURL(URL) { responseData, URLResponse, error in
            
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
    
    func fetchScheduleFor(parkType: ParkType) {
        let URLString = "https://api.wdpro.disney.go.com/facility-service/schedules/\(parkType.rawValue)"
        guard let URL = NSURL(string: URLString) else {
            return
        }
        
        requestWithURL(URL) { responseData, URLResponse, error in
            
            if let error = error {
                print(error)
                
            }
            
            guard let responseData = responseData else { return }
            
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
                
                print(response)
            } catch {
                
            }
        }
    }
    
    private func requestWithURL(URL: NSURL, completionHandler: ((NSData?, NSURLResponse?, NSError?) -> ())?) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Authorization" : "BEARER \(TokenManager.token!)",
            "Accept" : "application/json;apiversion=1",
            "X-Conversation-Id" : "~WDPRO-MOBILE.CLIENT-PROD"]
        
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let request = NSURLRequest(URL: URL)

        if let completionHandler = completionHandler {
            session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
        } else {
            session.dataTaskWithRequest(request).resume()
        }
    }
}