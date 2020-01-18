//
//  MySimpleShoppingListTableViewController.swift
//  mySimpleShoppingList
//
//  Created by Uzo on 1/17/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import UIKit
import CoreData

class MySimpleShoppingListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MySimpleShoppingListController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: Actions
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        print("Item Added")
        let alertController = UIAlertController(title: "Add Item", message: "Add an item to your shopping list", preferredStyle: .alert)
        
        let addNewItemButton = UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let itemName = alertController.textFields?.first?.text else { return }
            
            print(itemName)
            
            if itemName.isEmpty {
                return
            } else {
                MySimpleShoppingListController.sharedInstance.create(newItemWithName: itemName)
            }
        })
        
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (_) in }
        alertController.addAction(cancelButtonAction)
        alertController.addAction(addNewItemButton)
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return MySimpleShoppingListController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MySimpleShoppingListController.sharedInstance.fetchedResultsController.sectionIndexTitles[section] == "1" ? "Already Purchased" : "Pending"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MySimpleShoppingListController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? IsPurchasedTableViewCell else { return UITableViewCell() }
        
        let item = MySimpleShoppingListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.updateCell(WithItem: item)
        cell.delegate = self
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = MySimpleShoppingListController.sharedInstance.fetchedResultsController.object(at: indexPath)
            MySimpleShoppingListController.sharedInstance.delete(item: item)
        }
    }
}

extension MySimpleShoppingListTableViewController: PurchasedButtonCellDelegate {
    func cellButtonTapped(_ sender: IsPurchasedTableViewCell) {
        
        /// get the indexPath of the sender
        guard let indexPath = tableView.indexPath(for: sender) else {
            return
        }
        
        /// use the indexPath
        let item = MySimpleShoppingListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        MySimpleShoppingListController.sharedInstance.toggleIsPurchased(item: item)
        
        /// update the cell
        sender.updateIsPurchasedButtonImage(item.isPurchased)
        
    }
}

extension MySimpleShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else {break}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
}
