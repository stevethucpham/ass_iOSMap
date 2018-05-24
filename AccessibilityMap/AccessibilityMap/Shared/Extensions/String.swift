//
//  String.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/24/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
