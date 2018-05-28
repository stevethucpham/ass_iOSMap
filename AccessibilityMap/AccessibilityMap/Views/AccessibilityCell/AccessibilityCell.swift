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
    @IBOutlet weak var locationImage: ImageLoadingView!
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
            // self.locationImage.image = #imageLiteral(resourceName: "sample_image")
            self.locationImage.imageFromUrl(name: building.name, suburb: building.suburb)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accessibilityRating.isUserInteractionEnabled = false
        locationImage.layer.cornerRadius = 5
        locationImage.layer.borderColor = UIColor.lightGray.cgColor
        locationImage.layer.borderWidth = 0.5
    }
    
}
