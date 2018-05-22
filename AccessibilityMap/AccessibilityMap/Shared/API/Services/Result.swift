//
//  Result.swift
//  MelbourneDining
//
//  Created by Duy Thuc Pham on 4/13/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation

/// This enum uses to generic the result value from requesting API
///
/// - success: the json data
/// - failure: the error message
enum Result<Value> {
    case success(Value?)
    case failure(Error?)
}
