//
//  AllListsViewController.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import SwipeCellKit
import KRProgressHUD

class AllListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    var allLists:[ShoppingList] = []
    
    @IBOutlet weak var tableView: UITableView!
    var nameTextField: UITextField!
    
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KRProgressHUD.dismiss()
        
     loadLists()
    }
    
    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShoppingListTableViewCell
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        let shoppingList = allLists[indexPath.row]
        
        cell.bindData(item: shoppingList)
        
        return cell
    }
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "shoppingListToShoppingItemSeg", sender: indexPath)
        
    }
    
    //MARK: IBActions
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Create Shopping List", message: "Enter the shopping list name", preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            
            nameTextField.placeholder = "Name"
            self.nameTextField = nameTextField
            
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let saveAtion = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if self.nameTextField.text != "" {
                
                self.createShoppingList()
            } else {
                
                KRProgressHUD.showWarning(message: "Name is empty!")
                
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAtion)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: LoadLists
    
    func loadLists() {
        if(FUser.currentId() != KADMIN ){
         firebase.child(kSHOPPINGLIST).child(FUser.currentId()).observe(.value, with: {
            snapshot in
            
            self.allLists.removeAll()
            
            if snapshot.exists() {
                
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])
                
                
               
                for list in sorted {
                    
                    let currentList = list as! NSDictionary
                    
                    self.allLists.append(ShoppingList.init(dictionary: currentList))
                    
                }
                
            } else{
                print("no snapshot")
            }
            
            self.tableView.reloadData()
            
        })
        }
        if(FUser.currentId()==KADMIN){
            firebase.child(KLIST).observe(.value, with: {
                snapshot in

                self.allLists.removeAll()

                if snapshot.exists() {

                    let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])



                    for list in sorted {

                        let currentList = list as! NSDictionary

                        self.allLists.append(ShoppingList.init(dictionary: currentList))

                    }

                } else{
                    print("no snapshot")
                }

                self.tableView.reloadData()

            })
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shoppingListToShoppingItemSeg" {
            
            
            let indexPath = sender as! IndexPath
            let shoppingList = allLists[indexPath.row]
            
            let vc = segue.destination as! ShoppingItemViewController
            
            vc.shoppingList = shoppingList
        }
    }
    
    //MARK: SwipeTableviewCell delegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
        }
        
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            
            
            let item = self.allLists[indexPath.row]
            self.allLists.remove(at: indexPath.row)
            
            ShoppingItem.deleteAllShoppingItemsOfTheList(shoppingList: item, completion: { (success) in
                
                if success {
                    
                    item.deleteItemInBackground(shoppingList: item)
                    item.deleteItemad(shoppingList: item)
                    
                    
                }
            })
           
            
            
            // Coordinate table view update animations
            self.tableView.beginUpdates()
            action.fulfill(with: .delete)
            self.tableView.endUpdates()
            
        }
        
        configure(action: delete, with: .trash)
        return [delete]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
        
    }
    
    
    //MARK: Helper Functions
    
    func createShoppingList() {
        
        let shoppingList = ShoppingList(_name: nameTextField.text!)
        
        shoppingList.saveItemInBackground(shoppingList: shoppingList, completion: { (error) in
            
            if error != nil {
                
                KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                return
            }
            
        })
    }
    
    
}
