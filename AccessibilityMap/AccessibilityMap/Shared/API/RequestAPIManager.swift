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
    
    public func getBuildingInRange(lat: Double, long: Double, radius: Int, filterData: String? = nil ,  completionHandler: @escaping (_ result: Result<[Building]>) -> Void) {
        request(type: .getBuildings(radius: radius, lat: lat, long: long, filterData: filterData)) { responseHandler in
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
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    public func getBuildings(buildingName: String, paging: PaginationRequest, filterData: String? = nil , completionHandler: @escaping (_ result: Result<[Building]>) -> Void) -> DataRequest {
        let dataRequest: DataRequest
        if (buildingName == "") {
            dataRequest = getBuildings(paging: paging, filterData: filterData ,completionHandler: completionHandler)
        } else {
            dataRequest = request(type: .getBuildingByName(name: buildingName, paging: paging, filterData: filterData)) { responseHandler in
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
                    completionHandler(.failure(error))
                    break
                }
            }
        }
        return dataRequest
    }
    
    public func getBuildings(paging: PaginationRequest, filterData: String? = nil, completionHandler: @escaping (_ result: Result<[Building]>) -> Void) -> DataRequest {
        let dataRequest = request(type: .getBuilding(paging: paging, filterData: filterData)) { responseHandler in
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
                completionHandler(.failure(error))
                break
            }
        }
        return dataRequest
    }
    
    
    @discardableResult func request(type: RequestService, completionHandler: @escaping (_ result: Result<Data>) -> Void) -> DataRequest {
        let request = Alamofire.request("\(type.baseURL)\(type.path)", method: type.method, parameters: type.parameters, headers: type.headers).validate().responseData { handler in
//            debugPrint("All Response Info: \(handler)")
            switch handler.result {
            case .success:
                completionHandler(.success(handler.result.value))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
        return request
    }
}
