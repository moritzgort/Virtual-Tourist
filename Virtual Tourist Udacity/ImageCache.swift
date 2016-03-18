//
//  ImageCache.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 15/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    private var inMemoryCache = NSCache()
    
    class func sharedInstance() -> ImageCache {
        struct Static {
            static let instance = ImageCache()
        }
        return Static.instance
    }
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        if let image = inMemoryCache.objectForKey(identifier!) as? UIImage {
            return image
        }
        
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        if (image == nil) {
            inMemoryCache.removeObjectForKey(path)
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {
            }
            return
        }
        inMemoryCache.setObject(image!, forKey: path)
        
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
    }
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentationDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}