//
//  Dictionary.swift
//  UbiqApp
//
//  Created by admin on 5/8/17.
//  Copyright © 2017 ubiq. All rights reserved.
//

import Foundation

extension Dictionary {
    func dictByConcatinating(_ dictionary: [Key: Value]) -> [Key: Value] {
        var union = self
        for (k, v) in dictionary {
            union[k] = v
        }
        return union
    }
}
