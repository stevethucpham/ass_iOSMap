//
//  RequestService.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//
import UIKit
import Alamofire

enum RequestService {
    case getBuilding
    case getBuildings(radius: Int, lat: Double, long: Double)
    case getBuildingByName(name: String, paging: PaginationRequest?)
}


extension RequestService: RequestType {
    var baseURL: URL { return URL(string: Constant.baseURL)! }
    var path: String {
        switch self {
        case .getBuilding:
            return ""
        case .getBuildings:
            return ""
        case .getBuildingByName:
            return ""
        }
        
    }
    var method: HTTPMethod {
        switch self {
        case .getBuilding, .getBuildings, .getBuildingByName:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .getBuilding:
            return ["$where" : "building_name!='' AND accessibility_type!=''"]
        case .getBuildings(let radius, let lat, let long):
            let radiusParam = "within_circle(location,\(lat),\(long),\(radius))"
            return ["$where" : "building_name!='' AND accessibility_type!='' AND \(radiusParam)"]
        case .getBuildingByName(let name, let paging):
            let searchNameParam = "starts_with(building_name,'\(name)')"
            let searchParam: [String: Any] = ["$where" : "building_name!='' AND \(searchNameParam) AND accessibility_type!=''"] 
            guard let paging = paging else {
                return searchParam
            }
            return searchParam.dictByConcatinating(paging.toDict())
        default:
            return nil
        }
    }
    var headers: [String: String]? {
        switch self {
        default:
            return ["X-App-Token": "\(Constant.appToken)"]
        }
    }
}
