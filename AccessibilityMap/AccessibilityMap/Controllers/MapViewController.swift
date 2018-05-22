//
//  MapViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var searchBarView: SearchBarView!
    @IBOutlet weak var mapView: MKMapView!
    var lastLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0) {
        didSet {
            if (currentLocation.coordinate.latitude != lastLocation.coordinate.latitude && currentLocation.coordinate.longitude != lastLocation.coordinate.longitude) {
                lastLocation = currentLocation
                requestBuilding()
            }
        }
    }

    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupSearchBar()
        // TODO: Request
//        RequestAPIManager.shared.getBuildings { response in
//            switch response {
//            case .success(let buildings):
//                print(buildings)
//                break
//            case .failure(let error):
//                break
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        requestBuilding()
    }
}

// MARK: Setup view function
extension MapViewController {
    private func requestBuilding() {
        RequestAPIManager.shared.getBuildingInRange(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude, radius: 1000) { (response) in
            switch response {
                case .success(let buildings):
                    if let buildings = buildings {
                        var buildingList = Array(buildings)
                        buildingList = buildingList.filterDuplicates { $0.name.lowercased() == $1.name.lowercased() || $0.latitude == $1.latitude}
                        print(buildingList.count)
                        for building in buildingList {
                             let annotation =  AccessibilityMaker.accessibilityMaker(fromLocation: building)
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                    break
                case .failure(let error):
                    break
            }
        }
    }
    
    private func setupMap() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        mapView.showsCompass = false
        setTrackingButton()
        registerAnnotationViewClasses()
    }

    private func setupSearchBar() {
        searchBarView.searchText = "Test"
        searchBarView.searchButtonClicked = {
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let searchLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchNavigationViewController") as! UINavigationController
            self.present(searchLocationViewController, animated: true, completion: nil)
        }
        
        searchBarView.filterButtonClicked = {
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let filterViewController = mainStoryboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
            self.present(filterViewController, animated: true, completion: nil)
        }
    }
    
    func registerAnnotationViewClasses() {
        mapView.register(AccessibilityView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    
    // Define a place a tracking button
    private func setTrackingButton() {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if let marker = annotation as? AccessibilityMaker {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? AccessibilityView
            if view == nil {
                view = AccessibilityView(annotation: marker, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            return view
        } else if let cluster = annotation as? MKClusterAnnotation{
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? ClusterView
            if view == nil{
                view = ClusterView(annotation: cluster, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            }
            return view
        }
        else{
            return nil
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = CLLocation(latitude: locations[locations.count - 1].coordinate.latitude, longitude: locations[locations.count - 1].coordinate.longitude)
    }
}
