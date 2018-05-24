//
//  SpotLightManager.swift
//  Fuel Mate App
//
//  Created by iOS Developer on 4/9/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

struct SpotLightManager {
    static let shared =  SpotLightManager()
    
    /// Index Item With Spotlight
    ///
    /// - Parameters:
    ///   - title: spotlight title
    ///   - desc: spotlight description
    ///   - identifier: spotlight identifier
    ///   - keywords: spotlight keywords
    func indexItem(title: String, desc: String, identifier: String, keywords: [String]? = nil) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = title
        attributeSet.contentDescription = desc
        attributeSet.keywords = keywords
        let item = CSSearchableItem(uniqueIdentifier: "com.swinburne.accessibilitymap.\(identifier)", domainIdentifier: "location", attributeSet: attributeSet)
        setSearchableItems([item])
    }
    
    
    // Add or update specified list of CSSearchableItem.
    func setSearchableItems(_ searchableItems: [CSSearchableItem]){
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if let error =  error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Delete all searchable spotlight items.
    func deleteAllItems(_ completed: ((_ success: Bool)->())? = nil){
        CSSearchableIndex.default().deleteAllSearchableItems { (error) in
            let success = error == nil
            if let completed = completed {
                completed(success)
            }
        }
    }
    
    // Delete spotlight items by related group identifiers.
    func deleteItemsByGroup(_ groupNames: [String], completed: ((_ success: Bool)->())? = nil){
        
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: groupNames, completionHandler: { (error) in
            let success = error == nil
            if let completed = completed {
                completed(success)
            }
        })
    }
    
    // Delete spotlight list of spotlight items by related identifiers.
    func deleteItemById(_ identifiers: [String], completed: ((_ success: Bool)->())? = nil){
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: identifiers, completionHandler: { (error) in
            let success = error == nil
            if let completed = completed {
                completed(success)
            }
        })
    }
    // Handle spotlight when tap
    func spotlightItemTapAction(_ activity: NSUserActivity){
        if activity.activityType == CSSearchableItemActionType {
            if let userInfo = activity.userInfo {
                let selectedItem = userInfo[CSSearchableItemActivityIdentifier] as! String
                let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
                if navigationController.viewControllers.count > 1 {
                    navigationController.viewControllers.removeLast()
                }
                
            }
        }
    }
}
