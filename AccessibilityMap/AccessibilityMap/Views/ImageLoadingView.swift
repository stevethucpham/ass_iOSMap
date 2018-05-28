//
//  ImageLoadingView.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/28/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import BLMultiColorLoader

class ImageLoadingView: UIImageView {
    var indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    var noImageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        clipsToBounds = true
        backgroundColor = UIColor(hexString: "#E6E6E6")
        indicatorView.color = .red
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        indicatorView.addConstraint(NSLayoutConstraint(item: indicatorView,
                                                          attribute: .width,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1,
                                                          constant: 25))
        indicatorView.addConstraint(NSLayoutConstraint(item: indicatorView,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1,
                                                          constant: 25))
//        indicatorView.colorArray = [UIColor(hexString: Styles.Color.navigationBar)!]
        addConstraint(NSLayoutConstraint(item: indicatorView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: indicatorView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0))
//        indicatorView.startAnimation()
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        
        noImageLabel.isHidden = true
        noImageLabel.textAlignment = .center
        noImageLabel.textColor = UIColor(gray: 1, alpha: 0.4)
        noImageLabel.text = "No Image"
        noImageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noImageLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label]-10-|",
                                                      options: .directionLeftToRight,
                                                      metrics: nil,
                                                      views: ["label": noImageLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|",
                                                      options: .directionLeftToRight,
                                                      metrics: nil,
                                                      views: ["label": noImageLabel]))
    }
    
//    func
}
