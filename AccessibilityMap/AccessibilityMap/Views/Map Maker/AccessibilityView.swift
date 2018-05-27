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
            if let marker = newValue as? AccessibilityMaker {
                clusteringIdentifier = "building"
                if marker.building.rating == 3 {
                    markerTintColor = UIColor.blue
                } else if marker.building.rating == 2 {
                    markerTintColor = UIColor(hexString: Styles.Color.greenMarker)
                } else {
                    markerTintColor = UIColor(hexString: Styles.Color.lowRatingMarker)
                }
                
                glyphImage = UIImage(named: "map_marker")
                displayPriority = .defaultHigh
                titleVisibility = .visible
            }
        }
    }
    
}

