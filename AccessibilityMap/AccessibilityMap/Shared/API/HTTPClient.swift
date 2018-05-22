//
//  HTTPClient.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import Alamofire

struct HTTPClient {
    
    
    
    internal typealias RequestableCompletion = (HTTPURLResponse?, Data?, Error?) -> Void
    
    func request(type: RequestType, completionHandler: @escaping (Result<Data>) -> Void) {
        Alamofire.request("\(type.baseURL)/\(type.path)", method: type.method, parameters: type.parameters, headers: type.headers).validate().responseData { handler in
            switch handler.result {
            case .success:
                completionHandler(.success(handler.data))
                break
            case .failure(let error):
                completionHandler(.failure(handler.error))
                break
            }
        }
    }
}


