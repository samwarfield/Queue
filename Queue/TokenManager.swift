//
//  TokenManager.swift
//  Queue
//
//  Created by Adam Binsz on 12/15/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import Foundation

enum TokenError: ErrorType {
    case URLError
    case SerializationError
    case ResponseError
}

struct TokenManager {
    
    static private(set) var token: String?
    static private(set) var expirationDate: NSDate?
    
    static private var fetchingToken = false
    
    static func fetchToken(completion: ((token: String?, error: ErrorType?) -> ())? = nil) {
    
        guard let URL = NSURL(string: "https://authorization.go.com/token") else {
            completion?(token: nil, error: TokenError.URLError)
            return
        }
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let parameters = "grant_type=assertion&assertion_type=public&client_id=WDPRO-MOBILE.CLIENT-PROD"
        
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        session.dataTaskWithRequest(request) { responseData, URLResponse, error in
            
            guard let responseData = responseData else {
                completion?(token: nil, error: error)
                return
            }
            
            do {
                guard let response = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    completion?(token: nil, error: TokenError.SerializationError)
                    return
                }
                
                guard let token = response["access_token"] as? String else {
                    completion?(token: nil, error: TokenError.ResponseError)
                    return
                }
                
                self.token = token
                
                let expiration = response["expires_in"] as? Double ?? 900
                self.expirationDate = NSDate(timeIntervalSinceNow: expiration)
                
                completion?(token: token, error: nil)
                
            } catch {
                completion?(token: nil, error: TokenError.SerializationError)
                return
            }
        }.resume()
    }
    
    private init() {
        
    }
}