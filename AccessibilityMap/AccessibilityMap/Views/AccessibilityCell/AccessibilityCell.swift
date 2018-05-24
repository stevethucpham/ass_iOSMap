//
//  AccessibilityCell.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit



class AccessibilityCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var accessibilityRating: CosmosView!
    @IBOutlet weak var accessTypeLabel: UILabel!
    @IBOutlet weak var buildingAddressLabel: UILabel!
    
    var building: Building! {
        didSet {
            self.buildingNameLabel.text = building.name.capitalized
            self.accessibilityRating.rating = Double(building.rating)
            self.accessTypeLabel.text = building.type
            self.buildingAddressLabel.text = building.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accessibilityRating.isUserInteractionEnabled = false
    }
    
}
