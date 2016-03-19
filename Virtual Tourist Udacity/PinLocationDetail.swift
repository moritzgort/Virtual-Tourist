//
//  PinLocationDetail.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 16/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class PinLocationDetail: NSManagedObject {
    
    @NSManaged var locality: String
    @NSManaged var location: PinLocation
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(location:PinLocation, locality:String, context:NSManagedObjectContext) {
        self.init(context: context)
        
        self.locality = locality
        self.location = location
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
