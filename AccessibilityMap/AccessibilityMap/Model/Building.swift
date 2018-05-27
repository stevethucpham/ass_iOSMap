//
//  Building.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/21/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
struct Building: Decodable {
    private(set) var address: String
    private(set) var name: String
//    private(set) var constructionYear: Int
    private(set) var blockId: String
    private(set) var longitude: Double
    private(set) var latitude: Double
    private(set) var suburb: String
    private(set) var rating: Int
    private(set) var type: String
    private(set) var accessibilityDes: String
    
    enum BuildingKeys: String, CodingKey {
        case address = "street_address"
        case name = "lower_building_name"
//        case constructionYear = "construction_year"
        case blockId = "block_id"
        case longitude = "x_coordinate"
        case latitude = "y_coordinate"
        case suburb = "suburb"
        case rating = "accessibility_rating"
        case type = "accessibility_type"
        case accessibilityDes = "accessibility_type_description"
    }
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: BuildingKeys.self)
        address = try values.decode(String.self, forKey: .address)
        name = try values.decode(String.self, forKey: .name)
        blockId = try values.decode(String.self, forKey: .blockId)
        longitude = try Double(values.decode(String.self, forKey: .longitude)) ?? 0.0
        latitude = try Double(values.decode(String.self, forKey: .latitude)) ?? 0.0
        suburb = try values.decode(String.self, forKey: .suburb)
        rating = try Int(values.decode(String.self, forKey: .rating)) ?? 0
        type = try values.decode(String.self, forKey: .type)
        accessibilityDes = try values.decode(String.self, forKey: .accessibilityDes)
    }
    
    init (location: Location) {
        self.address = location.address!
        self.name = location.name!
        self.blockId = String(location.blockID)
        self.longitude = location.longitude
        self.latitude = location.latitude
        self.suburb = location.suburb!
        self.rating = Int(location.rating)
        self.type = location.type!
        self.accessibilityDes = location.accessibilityDes!
    }

}
