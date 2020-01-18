//
//  MySimpleShoppingListController.swift
//  mySimpleShoppingList
//
//  Created by Uzo on 1/17/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation
import CoreData

class MySimpleShoppingListController {
    
    static let sharedInstance = MySimpleShoppingListController()
    
    var fetchedResultsController: NSFetchedResultsController<Item>
    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isPurchased", ascending: true)]
        let resultsController: NSFetchedResultsController<Item> =
            NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "Purchased", cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch. Error is \(error): \(error.localizedDescription)")
        }
    }
    
    // MARK: CRUD
    func create(newItemWithName name: String?) {
        guard let itemName = name else {return}
        Item(name: itemName)
        saveToPersistentStore()
    }
    
    func toggleIsPurchased(item: Item) {
        item.isPurchased.toggle()
        saveToPersistentStore()
    }
    
    func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistentStore()
    }

    // MARK: Persistent Storage
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Content, item not saved")
        }
    }
}
