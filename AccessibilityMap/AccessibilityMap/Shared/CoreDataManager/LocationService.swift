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

    
//    func getAll()-> [Vehicle] {
//        return get(withPredicate: NSPredicate(value:true))
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
    
//    func getExpense(byUUID uuid: UUID) -> Expense? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Expense.entityName)
//        let predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
//        fetchRequest.predicate = predicate
//
//        do {
//            let response = try context.fetch(fetchRequest) as! [Expense]
//            return response.first
//
//        } catch let error as NSError {
//            // failure
//            print(error)
//            return nil
//        }
//    }
    
//    func get(withPredicate queryPredicate: NSPredicate) -> [Vehicle] {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Vehicle.entityName)
//
//        fetchRequest.predicate = queryPredicate
//
//        do {
//            let response = try context.fetch(fetchRequest)
//            return response as! [Vehicle]
//
//        } catch let error as NSError {
//            // failure
//            print(error)
//            return [Vehicle]()
//        }
//    }
    
//    func delete(expense: Expense) {
//        context.delete(expense)
//    }
//    
//    func deleteExpense(expense: Expense, byVehicle vehicle: Vehicle) {
//        vehicle.removeFromExpenses(expense)
//    }
//    
//    func delete(vehicle: Vehicle) {
//        context.delete(vehicle)
//    }
    
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
