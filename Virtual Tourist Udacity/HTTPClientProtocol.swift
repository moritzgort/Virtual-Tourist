//
//  HTTPClientProtocol.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 15/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation

public protocol HTTPClientProtocol {
    func getBaseURLSecure() -> String
    func addRequestHeaders(request: NSMutableURLRequest)
    func processJSONBody(jsonBody: [String:AnyObject]) -> [String:AnyObject]
    func processResponse(data: NSData) -> NSData
}