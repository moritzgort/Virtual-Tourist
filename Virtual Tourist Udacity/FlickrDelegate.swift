//
//  FlickrDelegate.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 10/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation

public protocol FlickrDelegate {
    func didSearchLocationImages(success: Bool, location: PinLocation, photos: [Photo]?, errorString: String?)
}