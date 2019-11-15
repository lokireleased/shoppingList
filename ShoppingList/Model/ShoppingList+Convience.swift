//
//  ShoppingList+Convience.swift
//  ShoppingList
//
//  Created by tyson ericksen on 11/15/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import Foundation
import CoreData


extension Item {
    
    convenience init(itemName: String, isBought: Bool = false, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        self.init(context: context)
        self.itemName = itemName
        self.isBought = isBought
    }
}
