//
//  mySimpleShoppingList+Convenience.swift
//  mySimpleShoppingList
//
//  Created by Uzo on 1/17/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    @discardableResult convenience init(name: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.isPurchased = false
    }
}
