//
//  RequestType.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import Alamofire

protocol RequestType {
    var baseURL: URL {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters: [String: Any]? {get}
    var headers: [String: String]? {get}
}
