//
//  DetailInfoWindowController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/25/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol DetailInfoWindowDelegate {
    func dimissViewController(annotation: MKAnnotation)
    func selectDetailInfoWindow(building: Building)
}

class DetailInfoWindowController: UIViewController {

    @IBOutlet weak var infoWindowView: DetailInfoWindow!
    var building: Building!
    var delegate: DetailInfoWindowDelegate!
    var currentMarker: MKAnnotation!
    var distance: Double!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoWindowView.building = building
        infoWindowView.distanceLabel.text = String(format: "%.2f km", distance/1000)
    }

    @IBAction func directionButtonClicked(_ sender: Any) {
        let directionString = "http://maps.apple.com/?saddr=\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)&daddr=\(String(describing: (self.building.latitude))),\(String(describing: (self.building.longitude)))"
        UIApplication.shared.open(URL(string: directionString)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func selectOutSide(_ sender: Any) {
        delegate.dimissViewController(annotation: currentMarker)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectInfoWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate.selectDetailInfoWindow(building: self.building)
    }
}
