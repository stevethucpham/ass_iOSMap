//
//  PagingRequest.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/22/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit

struct PaginationRequest {
    let limit: Int?
    let offset: Int?
    
    func nextPageRequest() -> PaginationRequest {
        return PaginationRequest(limit: (limit ?? 10), offset: (offset ?? 0) + (limit ?? 10))
    }
    
    func toDict() -> [String: Any] {
        var parameter: [String: Any] = [:]
        if let limit = limit {
            parameter["$limit"] = limit
        }
        if let offset = offset {
            parameter["$offset"] = offset
        }
        return parameter
    }
}
