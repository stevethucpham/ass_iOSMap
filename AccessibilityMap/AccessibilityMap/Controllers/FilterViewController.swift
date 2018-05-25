//
//  FilterViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

struct FilterData {
    var title: String
    var value: Any
}

class FilterViewController: UIViewController {
    
    var radiusItems = [FilterData(title: "0.5 km", value: 0.5),
                       FilterData(title: "1 km", value: 1),
                       FilterData(title: "2 km",  value: 2),
                       FilterData(title: "5 km", value: 5)]
    
    var orderItems = [FilterData(title: "All", value: "all"),
                      FilterData(title: "High rating", value: "accessibility_rating > 3"),
                      FilterData(title: "Medium rating", value: "(accessibility_rating > 1 AND accessibility_rating <=3)"),
                      FilterData(title: "Low rating", value: "accessibility_rating <= 1")]
    
    var radiusSelectedIndex: IndexPath?
    var sortSelectedIndex: IndexPath?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "FilterRadiusCell", bundle: nil), forCellReuseIdentifier: "radiusCell")
         UIApplication.shared.statusBarStyle = .lightContent
        let radius = UserDefaults.standard
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FilterViewController {
    private func setupRadiusCell(cell: FilterRadiusCell, indexPath: IndexPath) -> FilterRadiusCell {
        cell.filterRadiusLabel.text = radiusItems[indexPath.row].title
        if let radiusSelectedIndex = self.radiusSelectedIndex {
            cell.isChecked = radiusSelectedIndex == indexPath
        } else {
            cell.isChecked = false
        }
        return cell
    }
    
    private func setupSortCell(cell: FilterRadiusCell, indexPath: IndexPath) -> FilterRadiusCell {
        cell.filterRadiusLabel.text = orderItems[indexPath.row].title
        if let sortIndex = self.sortSelectedIndex {
            cell.isChecked = sortIndex == indexPath
        } else {
            cell.isChecked = false
        }
        return cell
    }
}

extension FilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return radiusItems.count
        }
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "radiusCell") as? FilterRadiusCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            return setupRadiusCell(cell: cell, indexPath: indexPath)
        }
        return setupSortCell(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Distance"
        }
        return "Filter"
    }
}



extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            radiusSelectedIndex = indexPath
        } else {
            sortSelectedIndex = indexPath
        }
        tableView.reloadData()
    }
    
}
