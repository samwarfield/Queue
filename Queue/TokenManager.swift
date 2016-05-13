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
    
    static let didUpdateTokenNotificationName = "didUpdateToken"
    
    static private(set) var token: String? {
        didSet {
            guard let _ = token else { return }
            NSNotificationCenter.defaultCenter().postNotificationName(didUpdateTokenNotificationName, object: nil)
        }
    }
    static private(set) var expirationDate: NSDate?
    
    static private(set) var fetchingToken = false
    
    static func fetchToken(completion: ((token: String?, error: ErrorType?) -> ())? = nil) {
        
        fetchingToken = true
    
        guard let URL = NSURL(string: "https://authorization.go.com/token") else {
            fetchingToken = false
            completion?(token: nil, error: TokenError.URLError)
            return
        }
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let parameters = "grant_type=assertion&assertion_type=public&client_id=\(clientId)"
        
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        session.dataTaskWithRequest(request) { responseData, URLResponse, error in
            
            var completionError: ErrorType? = error
            var completionToken: String?
            
            defer {
                fetchingToken = false
                completion?(token: completionToken, error: completionError)
            }
            
            guard let responseData = responseData else {
                return
            }
            
            do {
                guard let response = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    completionError = TokenError.SerializationError
                    return
                }
                
                guard let token = response["access_token"] as? String else {
                    completionError = TokenError.ResponseError
                    return
                }
                
                self.token = token
                
                print(token)
                
                let expiration = response["expires_in"] as? Double ?? 900
                self.expirationDate = NSDate(timeIntervalSinceNow: expiration)
                
                completionToken = token
                return
                
            } catch {
                completionError = TokenError.SerializationError
                return
            }
        }.resume()
    }
    
    private init() { }
}