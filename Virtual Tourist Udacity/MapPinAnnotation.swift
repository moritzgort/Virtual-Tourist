//
//  MapPinAnnotation.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 17/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import MapKit

public class MapPinAnnotation: NSObject, MKAnnotation {
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    public var location: PinLocation?
    
    init(latitude: Double, longitude: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        super.init()
    }
}