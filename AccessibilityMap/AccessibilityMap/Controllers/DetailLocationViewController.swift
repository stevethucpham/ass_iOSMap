//
//  DetailLocationViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import CoreLocation
import ParallaxHeader

class DetailLocationViewController: UIViewController {

    var currentLocation: CLLocation!
    var building: Building!
    var popToMap: ((_ building: Building) -> Void)?
    var selectMap: ((_ building: Building) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
        self.title = building.name.capitalized
        let imageView = ImageLoadingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        imageView.imageFromUrl(name: building.name, suburb: building.suburb)
//        imageView.contentMode = .scaleToFill
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.height = 250
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .topFill
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
        }
        tableView.register(UINib(nibName: "DetailInformationCell", bundle: nil), forCellReuseIdentifier: "detailInfoCell")
        tableView.register(UINib(nibName: "DetailAddressCell", bundle: nil), forCellReuseIdentifier: "detailAddressCell")
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        if let click = popToMap {
            click(building)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 300
    }
    
}

extension DetailLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfoCell") as? DetailInformationCell else {
                return UITableViewCell()
            }
            let blockId = Int(building.blockId)!
            cell.toogleBookmark = locationExist(blockID: blockId) != nil
            cell.building = building
            cell.bookmarkButtonClicked = { [unowned self] in
                // TODO: Set to local database
                if let location = self.locationExist(blockID: blockId) {
                    self.removeLocation(location: location, completion: { (isFinised) in
                        cell.toogleBookmark = false
                        print("Remove successfully")
                    })
                } else {
                    self.addLocation(building: self.building, completion: { (isFinised) in
                        cell.toogleBookmark = true
                        print("Save successfully")
                    })
                }
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailAddressCell") as? DetailAddressCell else {
            return UITableViewCell()
        }
        cell.building = building
        cell.directionButtonClicked = { [unowned self] in
            let directionString = "http://maps.apple.com/?saddr=\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)&daddr=\(String(describing: (self.building.latitude))),\(String(describing: (self.building.longitude)))"
            UIApplication.shared.open(URL(string: directionString)!, options: [:], completionHandler: nil)
        }
        cell.touchMapButtonClicked = {
            self.navigationController?.popToRootViewController(animated: true)
            if let click = self.selectMap {
                click(self.building)
            }
            
        }
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension DetailLocationViewController {
    
    
    private func addLocation(building: Building, completion: (_ completion: Bool) -> ()) {
        let locationService = LocationService(context: Constant.managedObjectContext)
        locationService.insertLocation(building: building)
        locationService.saveChanges(completion: completion)
        SpotLightManager.shared.indexItem(title: building.name.capitalized, desc: building.address, identifier: building.blockId , keywords: [building.name, building.address])
    }
    
    private func removeLocation(location: Location, completion: (_ completion: Bool) -> ()) {
        let locationService = LocationService(context: Constant.managedObjectContext)
        locationService.delete(location: location)
        locationService.saveChanges(completion: completion)
        SpotLightManager.shared.deleteItemById(["com.swinburne.accessibilitymap.\(location.blockID)"])
    }
    
    private func locationExist(blockID: Int) -> Location? {
        let locationService = LocationService(context: Constant.managedObjectContext)
        if let location = locationService.getLocation(byBlockID: blockID) {
            return location
        }
        return nil
    }
    
}
