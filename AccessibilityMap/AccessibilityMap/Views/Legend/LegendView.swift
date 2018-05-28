//
//  LegendView.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/28/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class LegendView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LegendView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowRadius = 10
        addSubview(contentView)
    }

}
