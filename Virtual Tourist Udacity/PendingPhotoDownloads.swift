//
//  PendingPhotoDownloads.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 16/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation

class PendingPhotoDownloads {
    
    class func sharedInstance() -> PendingPhotoDownloads {
        struct Static {
            static let instance = PendingPhotoDownloads()
        }
        return Static.instance
    }
    
    var downloadInProgress: [Int:AnyObject] = [Int:AnyObject]()
    var downloadQueue: NSOperationQueue
    var downloadWorkers: Set<PhotoDownloadWorker> = Set()
    
    override init() {
        downloadQueue = NSOperationQueue()
        downloadQueue.name = "Download Queue"
        downloadQueue.maxConcurrentOperationCount = 6
        super.init()
    }
}