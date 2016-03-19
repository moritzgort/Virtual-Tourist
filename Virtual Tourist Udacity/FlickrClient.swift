//
//  FlickrClient.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 10/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import CoreData

let FLICKR_API_KEY = "956b137ef192dfd744341614baff2f5f"

public class FlickrClient: NSObject, HTTPClientProtocol {
    
    var httpClient: HTTPClient?
    
    override init() {
        super.init()
        self.httpClient = HTTPClient(delegate: self)
    }
    
    public func getBaseURLSecure() -> String {
        return FlickrClient.Constants.BASE_URL
    }
    
    public func addRequestHeaders(request: NSMutableURLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    public func processJSONBody(jsonBody: [String: AnyObject]) -> [String: AnyObject] {
        return jsonBody
    }
    
    public func processResponse(data: NSData) -> NSData {
        return data
    }
    
    lazy var sharedModelContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().dataStack.childManagedObjectContext(NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
    }()
    
    public class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
}