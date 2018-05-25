//
//  FilterRadiusCell.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/25/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

protocol FilterRadiusDelegate {
    func checkboxClicked(indexPath: IndexPath, isChecked: Bool)
}

class FilterRadiusCell: UITableViewCell {

    @IBOutlet weak var filterRadiusLabel: UILabel!
    @IBOutlet weak var filterRadiusButton: UIButton!
    var delegate: FilterRadiusDelegate!
    var indexPath: IndexPath!
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                filterRadiusButton.setImage(#imageLiteral(resourceName: "checkbox_fill"), for: .normal)
            } else {
                filterRadiusButton.setImage(#imageLiteral(resourceName: "checkbox_empty"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBAction func checkboxClicked(_ sender: Any) {
//        isChecked = !isChecked
//        delegate.checkboxClicked(indexPath: self.indexPath, isChecked: isChecked)
    }
}
