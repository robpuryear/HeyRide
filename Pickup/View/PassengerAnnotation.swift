//
//  PassengerAnnotation.swift
//  Pickup
//
//  Created by Robert Puryear on 6/26/18.
//  Copyright © 2018 Robert Puryear. All rights reserved.
//

import Foundation
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
}
