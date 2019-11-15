//
//  ShoppingListController.swift
//  ShoppingList
//
//  Created by tyson ericksen on 11/15/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    static var sharedInstance = ShoppingListController()
    
    var items: [Item] {
        do {
        try fetchResultsController.performFetch()
            guard let items = fetchResultsController.fetchedObjects else { return [] }
            return items
        } catch {
            print("error in retrieving information", error, error.localizedDescription)
            return []
        }
    }
    
    var fetchResultsController: NSFetchedResultsController<Item> = {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    func creatItem(itemName: String) {
        _ = Item(itemName: itemName)
        saveItemToPersistentStorage()
    }
    
    func deleteItem(item: Item) {
        CoreDataStack.managedObjectContext.delete(item)
        saveItemToPersistentStorage()
    }
    
    func toggleIsBought(item: Item) {
        item.isBought.toggle()
        saveItemToPersistentStorage()
    }
    
    func  saveItemToPersistentStorage() {
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch {
            print("error in saving information", error, error.localizedDescription)
        }
    }
}
