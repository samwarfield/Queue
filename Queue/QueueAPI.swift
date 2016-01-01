//
//  QueueAPI.swift
//  Queue
//
//  Created by Adam Binsz on 12/31/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

struct QueueAPI {
    static func sendRequestWithURL(URL: NSURL, completionHandler: ((NSData?, NSURLResponse?, NSError?) -> ())?) {
        
        guard let token = TokenManager.token else {
            TokenManager.fetchToken { token, error in
                if let error = error {
                    completionHandler?(nil, nil, error as NSError)
                    return
                }
                sendRequestWithURL(URL, completionHandler: completionHandler)
            }
            return
        }
        
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