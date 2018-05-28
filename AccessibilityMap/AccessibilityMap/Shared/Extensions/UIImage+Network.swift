//
//  UIImage+Network.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/28/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit

extension ImageLoadingView {
    
    /// Request image from URL and caching
    ///
    /// - Parameter urlString: image link
    public func imageFromUrl(name: String, suburb: String) {
        image = nil
        RequestAPIManager.shared.getPlaceImage(buildingName: name.capitalized, suburb: suburb) { (result) in
            switch result {
            case .success(let photo):
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    self.image = photo
                    self.noImageLabel.isHidden = true
                }
                break
            case .failure(let error):
                print(error.debugDescription)
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
//                    self.image = #imageLiteral(resourceName: "no_image")
                    self.noImageLabel.isHidden = false
                }
                break
            }
        }
    }
}
