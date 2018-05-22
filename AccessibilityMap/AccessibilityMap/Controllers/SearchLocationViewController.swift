//
//  SearchLocationViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension SearchLocationViewController: UITableViewDelegate {
    
}

extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
