//
//  BookmarkViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import CoreLocation

class BookmarkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currentLocation: CLLocation!
    var locations: [Location] = [Location]()
    var buildings: [Building] = [Building]()
    var selectMap: ((_ building: Building) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
        fetchData()
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailLocationViewController =  segue.destination as? DetailLocationViewController {
            detailLocationViewController.currentLocation = self.currentLocation
            detailLocationViewController.building = sender as! Building
            detailLocationViewController.selectMap = selectMap
        }
    }
}
// MARK: Table View Data source
extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "accessibilityCell") as? AccessibilityCell else {
            return UITableViewCell()
        }
        cell.building = self.buildings[indexPath.row]
        return cell
    }
}
// MARK: Table view delegate
extension BookmarkViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailViewController", sender: buildings[indexPath.row])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.removeLocation(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
}

extension BookmarkViewController {
    
    private func removeLocation(at indexPath: IndexPath) {
        let locationService = LocationService(context: Constant.managedObjectContext)
        locationService.delete(location: locations[indexPath.row])
        locationService.saveChanges { (isFinished) in
            if isFinished {
                fetchData()
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "AccessibilityCell", bundle: nil), forCellReuseIdentifier: "accessibilityCell")
    }
    
    private func fetchData() {
        let locationService = LocationService(context: Constant.managedObjectContext)
        self.locations =  locationService.getAll()
        mappingDataToBuilding(listLocation: self.locations)
    }
    
    private func mappingDataToBuilding(listLocation: [Location]) {
        if listLocation.count >= 0 {
           self.buildings =  listLocation.map { (location) -> Building in
                let building = Building(location: location)
                return building
            }
        }
    }
}
