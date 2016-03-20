//
//  FlickrConvenience.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 10/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import CoreData

private let MAX_PHOTOS = 39

extension FlickrClient {
    
    public func getPhotosFromFlickrSearch(annotation:PinLocation, delegate:FlickrDelegate?) {
        self.getImageFromFlickrSearch(annotation) { success, result, errorString in
            print("Flickr search done")
            if success {
                let photos = [Photo]()
                var urls:[NSURL] = [NSURL]()
                for nextPhoto in result! {
                    if urls.count >= MAX_PHOTOS {
                        break
                    }
                    let imageUrlString = nextPhoto["url_m"] as? String
                    
                    if let imageURL = NSURL(string: imageUrlString!) {
                        urls.append(imageURL)
                    }
                }
                
                if let pinLocation = self.sharedModelContext.objectWithID(annotation.objectID) as? PinLocation {
                    _ = urls.map({ Photo(location: pinLocation, imageURL: $0, context: self.sharedModelContext)})
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "mergeChanges:", name: NSManagedObjectContextDidSaveNotification, object: self.sharedModelContext)
                    saveContext(self.sharedModelContext) { success in
                        dispatch_async(dispatch_get_main_queue()) {
                            delegate?.didSearchLocationImages(true, location: annotation, photos: photos, errorString: nil)
                        }
                    }
                }
                
            } else {
                delegate?.didSearchLocationImages(false, location: annotation, photos: nil, errorString: errorString)
            }
        }
    }
    
    public func mergeChanges(notification: NSNotification) {
        let mainContext: NSManagedObjectContext = CoreDataStackManager.sharedInstance().dataStack.managedObjectContext
        dispatch_async(dispatch_get_main_queue()) {
            mainContext.mergeChangesFromContextDidSaveNotification(notification)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    public func getImageFromFlickrSearch(annotation: PinLocation, completionHandler:(success: Bool, result: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let parameters = [
            FlickrClient.ParameterKeys.METHOD : FlickrClient.Methods.SEARCH,
            FlickrClient.ParameterKeys.API_KEY : FLICKR_API_KEY,
            FlickrClient.ParameterKeys.BBOX : self.createBoundingBoxString(annotation),
            FlickrClient.ParameterKeys.SAFE_SEARCH : FlickrClient.Constants.SAFE_SEARCH,
            FlickrClient.ParameterKeys.EXTRAS : FlickrClient.Constants.EXTRAS,
            FlickrClient.ParameterKeys.FORMAT : FlickrClient.Constants.DATA_FORMAT,
            FlickrClient.ParameterKeys.NO_JSON_CALLBACK : FlickrClient.Constants.NO_JSON_CALLBACK
        ]
        self.httpClient?.taskForGETMethod("", parameters: parameters) { JSONResult, error in if let _ = error {
            completionHandler(success: false, result: nil, errorString: "Can not find photos for location")
        } else {
            if let photosDictionary = JSONResult.valueForKey("photos") as? [String: AnyObject] {
                if let totalPages = photosDictionary["pages"] as? Int {
                    let pageLimit = min(totalPages, 40)
                    let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
                    self.getImageFromFlickrBySearchWithPage(parameters, pageNumber: randomPage, completionHandler: completionHandler)
                } else {
                    completionHandler(success: false, result: nil, errorString: "Can't find 'pages' in result")
                }
            } else {
                completionHandler(success: false, result: nil, errorString: "Can't find 'pages' in result")
            }
            }
        }
    }
    
    private func getImageFromFlickrBySearchWithPage(methodArguments: [String: AnyObject], pageNumber: Int, completionHandler: (success: Bool, result: [[String: AnyObject]]?, errorString: String?) -> Void) {
        var pageDictionary = methodArguments
        pageDictionary["page"] = pageNumber
        self.httpClient?.taskForGETMethod("", parameters: pageDictionary) {JSONResult, error in if let _ = error {
            completionHandler(success: false, result: nil, errorString: "Can't find photos for location")
        } else {
            if let photosDictionary = JSONResult.valueForKey("photos") as? [String:AnyObject] {
                var totalPhotosVal = 0
                if let totalPhotos = photosDictionary["total"] as? String {
                    totalPhotosVal = (totalPhotos as NSString).integerValue
                }
                
                if totalPhotosVal > 0 {
                    if let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] {
                        if photosArray.count > 0 {
                            completionHandler(success: true, result: photosArray, errorString: nil)
                        } else {
                            completionHandler(success: false, result: nil, errorString: "No Images for this location")
                        }
                    } else {
                        completionHandler(success: false, result: nil, errorString: "Can't find photo in response")
                    }
                } else {
                    completionHandler(success: false, result: nil, errorString: "No Photos found")
                }
            } else {
                completionHandler(success: false, result: nil, errorString: "Can't find photo in response")
            }
            }
    }
    }
    
    
    private func createBoundingBoxString(annotation: PinLocation) -> String {
        let latitude = annotation.latitude as Double
        let longitude = annotation.longitude as Double
        
        let bottom_left_lon = max(longitude - FlickrClient.Constants.BOUNDING_BOX_HALF_WIDTH, FlickrClient.Constants.LON_MIN)
        let bottom_left_lat = max(latitude - FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LAT_MIN)
        let top_right_lon = min(longitude + FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LON_MAX)
        let top_right_lat = min(latitude + FlickrClient.Constants.BOUNDING_BOX_HALF_HEIGHT, FlickrClient.Constants.LAT_MAX)
        
        return "\(bottom_left_lon), \(bottom_left_lat), \(top_right_lon), \(top_right_lat)"
    }
    
}