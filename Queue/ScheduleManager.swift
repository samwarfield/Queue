//
//  SchedulesManager.swift
//  Queue
//
//  Created by Adam Binsz on 12/23/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

struct ScheduleManager {
    
    typealias ScheduleFetchCompletionHandler = ([NSDate: Schedule]?, ErrorType?) -> ()
    
    static func fetchScheduleFor(parkType: ParkType, completionHandler: ScheduleFetchCompletionHandler?) {
        let URLString = "https://api.wdpro.disney.go.com/facility-service/schedules/\(parkType.rawValue)"
        guard let URL = NSURL(string: URLString) else {
            return
        }
        
        requestWithURL(URL) { responseData, URLResponse, error in
            
            var schedule: [NSDate: Schedule]?
            var completionError: NSError? = error
            
            defer {
                completionHandler?(schedule, completionError)
            }
            
            if let _ = error {
                return
            }
            
            guard let responseData = responseData else { return }
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
                guard let scheduleArray = response["schedules"] as? [[String: AnyObject]] else { return }
                schedule = [NSDate: Schedule]()
                for day in scheduleArray {
                    if let day = Schedule(rawValue: day) {
                        schedule?[day.date] = day
                    }
                }
            } catch {
                return
            }
        }
    }
    
    private static func requestWithURL(URL: NSURL, completionHandler: ((NSData?, NSURLResponse?, NSError?) -> ())?) {
        
//        while (TokenManager.token == nil && TokenManager.fetchingToken) { }
        
        guard let token = TokenManager.token else { return }
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Authorization" : "BEARER \(token)",
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