//
//  FlickrPhotoDelegate.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 16/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation

public class FlickrPhotoDelegate: FlickrDelegate {
    
    class func sharedInstance() -> FlickrPhotoDelegate {
        struct Static {
            static let instance = FlickrPhotoDelegate()
        }
        return Static.instance
    }
    
    var onLoad: Set<PinLocation> = Set()
    var delegates: [PinLocation:FlickrDelegate] = [PinLocation:FlickrDelegate]()
    
    public func didSearchLocationImages(success: Bool, location: PinLocation, photos: [Photo]?, errorString: String?) {
        self.onLoad.remove(location)
        if let delegate = delegates[location] {
            delegate.didSearchLocationImages(success, location: location, photos: photos, errorString: errorString)
        }
        self.delegates.removeValueForKey(location)
    }
    
    public func searchPhotos(location: PinLocation) {
        self.onLoad.insert(location)
        FlickrClient.sharedInstance().getPhotosFromFlickrSearch(location, delegate: self)
    }
    
    public func isLoading(location: PinLocation) -> Bool {
        return self.onLoad.contains(location)
    }
    
    public func addDelegate(location: PinLocation, delegate: FlickrDelegate) {
        delegates[location] = delegate
    }
}