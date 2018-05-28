//
//  UIImage+Network.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/28/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Request image from URL and caching
    ///
    /// - Parameter urlString: image link
    public func imageFromUrl(name: String, suburb: String) {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.color = .red
        self.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: indicatorView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: indicatorView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        image = nil
        
        RequestAPIManager.shared.getPlaceImage(buildingName: name.capitalized, suburb: suburb) { (result) in
            switch result {
            case .success(let photo):
                DispatchQueue.main.async {
                    indicatorView.stopAnimating()
                    self.image = photo
                }
                break
            case .failure(let error):
                print(error.debugDescription)
                DispatchQueue.main.async {
                    indicatorView.stopAnimating()
                    self.image = #imageLiteral(resourceName: "no_image")
                }
                break
            }
        }
    }
}
