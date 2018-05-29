//
//  VehicleService.swift
//  Fuel Mate App
//
//  Created by iOS Developer on 4/8/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Location {
    static let entityName = "Location"
}


class LocationService {
    
    /// NSManageObjectContext of Vehicle
    var context: NSManagedObjectContext
    
    /// Init with NSManagedObjectContext
    ///
    /// - Parameter context: curent context
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func insertLocation(building: Building) {
        let newItem =  NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: context) as! Location
        newItem.blockID = Int16(building.blockId)!
        newItem.accessibilityDes = building.accessibilityDes
        newItem.address = building.address
        newItem.latitude = building.latitude
        newItem.longitude = building.longitude
        newItem.name = building.name
        newItem.rating = Int16(building.rating)
        newItem.type = building.type
        newItem.suburb = building.suburb
    }
    
    func getAll() -> [Location] {
        return get(withPredicate: NSPredicate(value:true))
    }

    func getLocation(byBlockID blockID: Int) -> Location? {
        let predicate = NSPredicate(format: "blockID == %d", blockID)
        return get(withPredicate: predicate).first
    }
    
    
    func get(withPredicate queryPredicate: NSPredicate) -> [Location] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Location.entityName)

        fetchRequest.predicate = queryPredicate

        do {
            let response = try context.fetch(fetchRequest)
            return response as! [Location]

        } catch let error as NSError {
            // failure
            print(error)
            return [Location]()
        }
    }
    
    func delete(location: Location) {
        context.delete(location)
    }
    
    // Saves all changes
    func saveChanges(completion: (_ completion: Bool) -> ()) {
        do{
            try context.save()
            completion(true)
        } catch let error as NSError {
            // failure
            debugPrint("Could not save \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
