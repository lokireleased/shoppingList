//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by tyson ericksen on 11/15/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ShoppingListController.sharedInstance.fetchResultsController.delegate = self
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Item", message: "Whatcha need?", preferredStyle: .alert)
        let addButtonAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let newItem = alertController.textFields?[0].text else { return }
            ShoppingListController.sharedInstance.creatItem(itemName: newItem)
        }
        let cancelButtonAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (_) in }
        alertController.addAction(addButtonAction)
        alertController.addAction(cancelButtonAction)
        self.present(alertController, animated: true)
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.sharedInstance.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let item = ShoppingListController.sharedInstance.fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = item.itemName
        cell.delegate = self
        cell.updateView(item: item)
    
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ShoppingListController.sharedInstance.items[indexPath.row]
            ShoppingListController.sharedInstance.deleteItem(item: item)
        }
    }
}

extension ShoppingListTableViewController: itemTableViewCellDelegate {
    func isBoughtTapped(_ sender: ItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let item = ShoppingListController.sharedInstance.fetchResultsController.object(at: indexPath)
        ShoppingListController.sharedInstance.toggleIsBought(item: item)
        sender.updateView(item: item)
    }
    
    
}

// MARK: - Fetched Results Controller Delegate
extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
            
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

