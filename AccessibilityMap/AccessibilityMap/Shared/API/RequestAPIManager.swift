//
//  RequestAPIManager.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import Alamofire

class RequestAPIManager {
    
    private init () {}
    
    static let shared = RequestAPIManager()
    
    
    
    public func getBuildings(completionHandler: @escaping (_ result: Result<[Building]>) -> Void) {
        request(type: .getBuildingByName(name: "E", paging: PaginationRequest(limit: 10, offset: 0))) { responseHandler in
            switch responseHandler {
            case .success(let data):
                do {
                    let buildings = try JSONDecoder().decode([Building].self, from: data!)
                    completionHandler(.success(buildings))
                } catch let error {
                    debugPrint(error.localizedDescription)
                    completionHandler(.failure(error))
                }
                break
            case .failure(let error):
                debugPrint(error?.localizedDescription)
                break
            }
        }
    }
    
    
    func request(type: RequestService, completionHandler: @escaping (_ result: Result<Data>) -> Void) {
        Alamofire.request("\(type.baseURL)\(type.path)", method: type.method, parameters: type.parameters, headers: type.headers).validate().responseData { handler in
            debugPrint("All Response Info: \(handler)")
            switch handler.result {
            case .success:
                completionHandler(.success(handler.result.value))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
}
