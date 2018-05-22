//
//  AccessibilityMarker.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/22/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import MapKit

class AccessibilityMaker: MKPointAnnotation {
    class func accessibilityMaker(fromLocation building: Building)-> AccessibilityMaker {
        let accessibilityMaker = AccessibilityMaker()
        accessibilityMaker.coordinate = CLLocationCoordinate2DMake(building.latitude, building.longitude)
        accessibilityMaker.title = building.name
        return accessibilityMaker
    }
}
