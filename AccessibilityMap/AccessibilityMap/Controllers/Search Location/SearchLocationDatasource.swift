//
//  SearchLocationDatasource.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/24/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import Alamofire

class SearchLocationDatasource {
    private(set) var buildings = [Building]()
    private(set) var paginationRequest: PaginationRequest = PaginationRequest(limit: 10, offset:0)
    private(set) var isLoading: Bool = false
    private var currentQuery: String? = nil
    private(set) var currentRequest: DataRequest? = nil
    
    func loadFirstPage(_ query: String? = nil, completion: @escaping (Result<Void>) -> Void) {
        currentQuery = query
        paginationRequest = PaginationRequest(limit: 10, offset:0)
        buildings = []
        loadCurrentPage(completion: completion)
    }
    
    func loadCurrentPage(completion: @escaping (Result<Void>) -> Void) {
//        currentRequest?.cancel()
        
        isLoading = true
        var query = ""
        if currentQuery != nil {
            query = currentQuery!
        }
        currentRequest = RequestAPIManager.shared.getBuildings(buildingName: query, paging: paginationRequest) { (result) in
            self.isLoading = false
            switch result {  
            case .success(let list):
                if let list = list {
                    let buildingList = self.filterDuplicateData(accessibilityList: list)
                    self.buildings.append(contentsOf: buildingList)
                    completion(.success(nil))
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func filterDuplicateData(accessibilityList: [Building]) -> [Building] {
        var buildingList = Array(accessibilityList)
        buildingList = buildingList.filterDuplicates { $0.name.lowercased() == $1.name.lowercased() || $0.latitude == $1.latitude}
        return buildingList
    }
    
    func clearResults() {
        buildings.removeAll()
    }
    
    func loadMore(completion: @escaping (Result<Void>) -> Void) {
        if  !isLoading {
            paginationRequest = paginationRequest.nextPageRequest()
            loadCurrentPage(completion: completion)
        }
    }
}
