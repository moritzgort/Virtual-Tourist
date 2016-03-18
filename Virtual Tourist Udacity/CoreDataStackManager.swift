//
//  CoreDataStackManager.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 10/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStackManager {
    
    class func sharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    
    lazy var dataModel: CoreDataModel = {
        return CoreDataModel(name: "VirtualTourist")
    }()
    
    lazy var dataStack: CoreDataStack = {
        return CoreDataStack(model: self.dataModel)
    }()
    
    func saveContext() {
        var error: NSError? = nil
        if self.dataStack.managedObjectContext.hasChanges {
            do {
                try self.dataStack.managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
}