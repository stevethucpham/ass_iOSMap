//
//  MapViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RequestAPIManager.shared.getBuildings { response in
            switch response {
            case .success(let buildings):
                print(buildings)
                break
            case .failure(let error):
                break
            }
        }
    }


}
