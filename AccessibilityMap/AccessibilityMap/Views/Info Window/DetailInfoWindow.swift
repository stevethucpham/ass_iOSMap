//
//  DetailInfoWindow.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/25/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class DetailInfoWindow: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var accessRatingView: CosmosView!
    @IBOutlet weak var accessTypeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var building: Building! {
        didSet {
            buildingNameLabel.text = building.name.capitalized
            suburbLabel.text = building.suburb
            accessRatingView.rating = Double(building.rating)
            accessTypeLabel.text = building.type
            addressLabel.text = building.address
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("DetailInfoWindow", owner: self, options: nil)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        addSubview(containerView)
    }

}
