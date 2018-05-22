//
//  ArrayExtension.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/22/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit
extension Array {
    
    func filterDuplicates( includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
