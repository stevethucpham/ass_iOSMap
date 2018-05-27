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
    
    /// Insert vehicle to database
    ///
    /// - Parameters:
    ///   - brand: vehicle brand
    ///   - model: vehicle model
    ///   - year: manufactured year of vehicle
    ///   - fuelTank: fuel tank
//    func insertVehicle(brand: String, model: String, year: Int, fuelTank: Double) {
//        let newItem = NSEntityDescription.insertNewObject(forEntityName: Vehicle.entityName, into: context) as! Vehicle
//        newItem.brand = brand
//        newItem.model = model
//        newItem.manufactureYear = Int16(year)
//        newItem.fuelTankCapacity = fuelTank
//        newItem.uuid = UUID()
//    }
    
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
    /// Insert expense into vehicle
    ///
    /// - Parameters:
    ///   - vehicle: vehicle which has the
    ///   - amount: expense amount
    ///   - date: expense date
    ///   - litre: expense litre
    ///   - localtion: expense lcoatio
    /// - Returns: expense
//    func insertExpenseToVehicle(vehicle: Vehicle, amount: Double, date: Date, litre: Double, localtion: String) -> Expense {
//
//        let newExpense = NSEntityDescription.insertNewObject(forEntityName: Expense.entityName, into: context) as! Expense
//        newExpense.expAmount = amount
//        newExpense.expDate = date
//        newExpense.expLitre = litre
//        newExpense.location = localtion
//        newExpense.uuid = UUID()
//        vehicle.addToExpenses(newExpense)
//        return newExpense
//    }

    

    
//    func getExpenses(byVehicle vehicle: Vehicle) -> [Expense] {
//        return (vehicle.expenses?.toArray())!
//    }
    
//    func getVehicle(byExpenseID expenseID: String) -> Vehicle? {
//        let uuid = UUID(uuidString: expenseID)
//        if let expense = getExpense(byUUID: uuid!) {
//            return expense.vehicle
//        }
//        return nil
//    }
    
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
