//
//  DetailAddressCell.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/25/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import MapKit

class DetailAddressCell: UITableViewCell {

    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var directionButtonClicked: (() -> Void)?
    
    var touchMapButtonClicked: (() -> Void)?
    
    var building: Building! {
        didSet {
            self.addressLabel.text = building.address
            let annotation = AccessibilityMaker(building: building)
            detailMapView.addAnnotation(annotation)
            detailMapView.selectAnnotation(annotation, animated: true)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate,
                                                                      1000, 1000)
            detailMapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchOnMap(_ sender: Any) {
        if let click = touchMapButtonClicked {
            click()
        }
    }
    @IBAction func directionButtonClicked(_ sender: Any) {
        if let click = directionButtonClicked {
            click()
        }
    }
    
}
