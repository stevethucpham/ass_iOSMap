//
//  ShopView.swift
//  GPS_Map_App
//
//  Created by Duy Thuc Pham on 07/05/2018.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import MapKit

class AccessibilityView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            if (newValue as? AccessibilityMaker) != nil {
                clusteringIdentifier = "building"
                markerTintColor = UIColor.blue
                glyphImage = UIImage(named: "map_marker")
                displayPriority = .defaultHigh
                titleVisibility = .visible
            }
        }
    }
    
}

