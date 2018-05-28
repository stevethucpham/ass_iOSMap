//
//  CacheManager.swift
//  AccessibilityMap
//
//  Created by Duy Thuc Pham on 4/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit

struct CacheManager {
    let imageCache = NSCache<AnyObject, UIImage>()
    
    func setImage(image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as AnyObject)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        guard let imageFromCache = imageCache.object(forKey: key as AnyObject) else {
            return nil
        }
        return imageFromCache
    }
}

