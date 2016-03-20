//
//  PinLocation.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 16/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import CoreData

@objc(PinLocation)

public class PinLocation : NSManagedObject {
    
    @NSManaged public var latitude:NSNumber
    @NSManaged public var longitude:NSNumber
    @NSManaged public var myPhotos:[Photo]
    @NSManaged public var details:PinLocationDetail?
    
    override public var description:String {
        get {
            return "latitude:\(self.latitude)::longitude:\(self.longitude)"
        }
    }
    
    override public var hashValue : Int {
        get {
            return self.description.hashValue
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(latitude:NSNumber, longitude:NSNumber, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func isDownloading() -> Bool {
        var result = false
        
        for next in self.myPhotos {
            if let downloadWorker = PendingPhotoDownloads.sharedInstance().downloadInProgress[next.description.hashValue] as? PhotoDownloadWorker {
                if downloadWorker.isDownloading() {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
}

public func ==(lhs:PinLocation, rhs: PinLocation) -> Bool {
    return lhs.latitude.isEqualToNumber(rhs.latitude) && lhs.longitude.isEqualToNumber(rhs.longitude)
}