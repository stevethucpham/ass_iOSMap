//
//  RequestAPIManager.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import Alamofire
import GooglePlaces

enum RequestError: Error {
    case noImage (String)
}

class RequestAPIManager {
    
    private init () {}
    
    static let shared = RequestAPIManager()
     private let cacheManager = CacheManager()
    
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
    
    
    public func getPlaceImage(buildingName: String, suburb: String, completionHandler: @escaping (_ result: Result<UIImage>) -> Void) {
        if let imageFromCache = cacheManager.getImage(forKey: buildingName) {
            completionHandler(.success(imageFromCache))
            return
        }
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        let query = "\(buildingName) ,Melbourne VIC, Australia"
        GMSPlacesClient.shared().autocompleteQuery(query, bounds: nil, filter: filter) { (result, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let result = result, result.count > 0 {
                self.getPhoto(placeID: (result.first?.placeID)!, completionHandler: { (photo, error) in
                    if let error = error {
                        completionHandler(.failure(error))
                        return
                    }
                    if let photo = photo {
                        self.cacheManager.setImage(image: photo, forKey: buildingName)
                        completionHandler(.success(photo))
                    }
                    
                })
            } else {
                completionHandler(.failure(RequestError.noImage("No Image")))
            }
        }
    }
    

    
    public func getPhoto(placeID: String, completionHandler: @escaping (_ result: UIImage?, _ error: Error?) ->Void) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                completionHandler(nil, RequestError.noImage("No Image"))
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto, completionHandler: completionHandler)
                } else {
                    print("Error: no image")
                    completionHandler(nil, RequestError.noImage("No Image"))
                }
            }
        }
    }
    
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, completionHandler: @escaping (_ result: UIImage?, _ error: Error?) ->Void) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, constrainedTo: CGSize(width: 800, height: 600), scale: 1.0) { (photo, error) in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                completionHandler(nil, RequestError.noImage("No Image"))
            } else {
                completionHandler(photo, nil)
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
