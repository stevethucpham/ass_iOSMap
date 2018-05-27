//
//  DetailInformationCell.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/25/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class DetailInformationCell: UITableViewCell {

    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var accessTypeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var accessDescription: UILabel!
    
    var toogleBookmark: Bool! {
        didSet {
            if toogleBookmark == true {
                self.bookMarkButton.setImage(#imageLiteral(resourceName: "bookmark_fill"), for: .normal)
            }
            else {
                self.bookMarkButton.setImage(#imageLiteral(resourceName: "bookmark_notfill"), for: .normal)
            }
        }
    }
    
    var building: Building! {
        didSet {
            buildingNameLabel.text = building.name.capitalized
            accessTypeLabel.text = building.type
            ratingView.rating = Double(building.rating)
            accessDescription.text = building.accessibilityDes
        }
    }
    
    var bookmarkButtonClicked: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func bookmarkClicked(_ sender: Any) {
        if let click = bookmarkButtonClicked {
            click()
        }
    }
    
    
}
