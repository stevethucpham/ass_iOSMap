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
                let radius = UserDefaults.standard.integer(forKey: "radius")
                let filterData = UserDefaults.standard.string(forKey: "ratingFilter") ?? ""
                if filterData == "all" {
                    requestBuilding(radius: radius)
                } else {
                    requestBuilding(radius: radius, filterData: filterData)
                }
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
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailLocationViewController {
            let barButtonItem = UIBarButtonItem()
            barButtonItem.title = ""
            navigationItem.backBarButtonItem = barButtonItem
            detailViewController.building = sender as! Building
        }
    }
}

// MARK: Setup view function
extension MapViewController {
    
    private func removeMarkers() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func requestBuilding(radius: Int, filterData: String? = nil) {
        LoadingIndicator.shared.show()
        RequestAPIManager.shared.getBuildingInRange(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude, radius: radius, filterData: filterData) { [unowned self] (response) in
            LoadingIndicator.shared.hide()
            switch response {
                case .success(let buildings):
                    if let buildings = buildings {
                        self.removeMarkers()
                        var buildingList = Array(buildings)
                        buildingList = buildingList.filterDuplicates { $0.name.lowercased() == $1.name.lowercased() || $0.latitude == $1.latitude}
                        debugPrint(buildingList.count)
                        for building in buildingList {
                            let annotation = AccessibilityMaker(building: building)
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                    break
                case .failure(let error):
                    print(error?.localizedDescription ?? "")
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
//        searchBarView.searchText = "Test"
        searchBarView.searchButtonClicked = {
//            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let searchLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchNavigationViewController") as! UINavigationController
//            let searchVC = searchLocationViewController.viewControllers.first as! SearchLocationViewController
            self.present(searchLocationViewController, animated: true, completion: nil)
        }
        
        searchBarView.filterButtonClicked = {
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let filterNavViewController = mainStoryboard.instantiateViewController(withIdentifier: "FilterNavigationViewController") as! UINavigationController
            let filterVC = filterNavViewController.viewControllers.first as! FilterViewController
            filterVC.delegate = self
            self.present(filterNavViewController, animated: true, completion: nil)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let marker = view.annotation as? AccessibilityMaker {
//            print(marker.building.name)
            mapView.setCenter(marker.coordinate, animated: true)
            let infoWindowController = DetailInfoWindowController(nibName: "DetailInfoWindowController", bundle: nil)
            infoWindowController.building = marker.building
            infoWindowController.currentMarker = marker
            infoWindowController.modalPresentationStyle = .overCurrentContext
            infoWindowController.delegate = self
            let markerLocation = CLLocation(latitude: marker.building.latitude, longitude: marker.building.longitude)
            let distanceInMeters = currentLocation.distance(from: markerLocation)
            infoWindowController.distance = distanceInMeters
            self.present(infoWindowController, animated: true, completion: nil)
        }
    }
}

extension MapViewController: DetailInfoWindowDelegate {
    
    func dimissViewController(annotation: MKAnnotation) {
        self.mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func selectDetailInfoWindow(building: Building) {
        performSegue(withIdentifier: "showDetailViewController", sender: building)
    }
}

extension MapViewController: FilterDelgate {
    func displayMap(radius: Int, filterData: String) {
        if filterData == "all" {
            requestBuilding(radius: radius)
        } else {
            requestBuilding(radius: radius, filterData: filterData)
        }
        mapView.setCenter(currentLocation.coordinate, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = CLLocation(latitude: locations[locations.count - 1].coordinate.latitude, longitude: locations[locations.count - 1].coordinate.longitude)
    }
}
