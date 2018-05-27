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
    case getBuilding(paging: PaginationRequest?, filterData: String?)
    case getBuildings(radius: Int, lat: Double, long: Double, filterData: String?)
    case getBuildingByName(name: String, paging: PaginationRequest?, filterData: String?)
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
        let filterParam: [String: Any] = ["$select" : "block_id, accessibility_rating, accessibility_type, accessibility_type_description, lower(building_name), location, street_address,suburb,x_coordinate,y_coordinate", "$group" : "block_id, accessibility_rating, accessibility_type, accessibility_type_description, lower(building_name), location, street_address,suburb,x_coordinate,y_coordinate", "$order" : "block_id"]
        switch self {
        case .getBuilding(let paging, let filterData):
            var searchParam: [String: Any] = filterParam.dictByConcatinating(["$where" : "building_name!='' AND accessibility_type!='' AND census_year=2016"])
            guard let paging = paging else {
                return searchParam
            }
            if let filterData = filterData {
                searchParam = filterParam.dictByConcatinating(["$where" : "building_name!='' AND accessibility_type!='' AND census_year = 2016 AND \(filterData)"])
            }
            return searchParam.dictByConcatinating(paging.toDict())
        case .getBuildings(let radius, let lat, let long, let filterData):
            let radiusParam = "within_circle(location,\(lat),\(long),\(radius))"
            if let filterData = filterData {
                return filterParam.dictByConcatinating(["$where" : "building_name!='' AND accessibility_type!='' AND census_year = 2016 AND \(radiusParam) AND \(filterData)"])
            }
            return filterParam.dictByConcatinating(["$where" : "building_name!='' AND accessibility_type!='' AND census_year = 2016 AND \(radiusParam)"])
        case .getBuildingByName(let name, let paging, let filterData):
            let searchNameParam = "starts_with(building_name,'\(name)')"
            var searchParam: [String: Any] = filterParam.dictByConcatinating(["$where" : "building_name!='' AND \(searchNameParam) AND accessibility_type!='' AND census_year = 2016"])
            guard let paging = paging else {
                return searchParam
            }
            if let filterData = filterData {
                searchParam = filterParam.dictByConcatinating(["$where" : "building_name!='' AND \(searchNameParam) AND accessibility_type!='' AND census_year = 2016 AND \(filterData)"])
            }
            return searchParam.dictByConcatinating(paging.toDict())
        }
    }
    var headers: [String: String]? {
        switch self {
        default:
            return ["X-App-Token": "\(Constant.appToken)"]
        }
    }
}
