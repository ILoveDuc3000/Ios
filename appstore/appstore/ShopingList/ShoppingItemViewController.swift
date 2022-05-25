//
//  ShoppingItemViewController.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import SwipeCellKit
import KRProgressHUD

class ShoppingItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SearchItemViewControllerDelegate {
    
    var shoppingList: ShoppingList!
    
    var shoppingItems: [ShoppingItem] = []
    var boughtItems: [ShoppingItem] = []
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = true
    
    var totalPrice: Float!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackArrow"), style: .plain, target: self, action: #selector(self.backAction))
        
        
        totalPrice = shoppingList.totalPrice
        loadShoppingItems()
        updateUI()
    }
    
    @objc func backAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Tableview DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return shoppingItems.count
        } else {
            
            return boughtItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        var item: ShoppingItem!
        
        if indexPath.section == 0 {
            
            item = shoppingItems[indexPath.row]
        } else {
            
            item = boughtItems[indexPath.row]
        }
        
        cell.bindData(item: item)
        
        return cell
    }
    
    //MARK: Tableview delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddShoppingItemViewController
        
        
        vc.shoppingList = shoppingList
        vc.shoppingItem = self.shoppingItems[indexPath.row]
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title: String!
        
        if section == 0 {
            title = "SHOPPING LIST"
        } else {
            title = "BOUGHT LIST"
        }
        
        return titleViewForTable(titleText: title)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    
    
    //MARK: IBActions
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newItem = UIAlertAction(title: "New Item", style: .default) { (alert: UIAlertAction!) in
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddShoppingItemViewController
            
            
            vc.shoppingList = self.shoppingList
            vc.addingToList = false
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
        let searchItem = UIAlertAction(title: "Search Item", style: .default) { (alert: UIAlertAction!) in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchItemViewController
            
            vc.clickToEdit = false
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
            
        }
        
        optionMenu.addAction(newItem)
        optionMenu.addAction(searchItem)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: Load ShoppingItems
    
    func loadShoppingItems() {
        firebase.child(kSHOPPINGITEM).child(shoppingList.id).queryOrdered(byChild: kSHOPPINGLISTID).queryEqual(toValue: shoppingList.id).observe(.value, with: {
            snapshot in
            
            self.shoppingItems.removeAll()
            self.boughtItems.removeAll()
            
            if snapshot.exists() {
                
                let allItems = (snapshot.value as! NSDictionary).allValues as NSArray
                
                
                for item in allItems {
                    
                    let currentItem = ShoppingItem.init(dictionary: item as! NSDictionary)
                    
                    if currentItem.isBought {
                        
                        self.boughtItems.append(currentItem)
                        
                    } else {
                        
                        self.shoppingItems.append(currentItem)
                        
                    }
                    
                }
                
            } else{
                
                print("no snapshot")
            }
            
            self.culculateTotal()
            self.updateUI()
        })
        
    }
    
    //MARK: UpdateUI
    
    func updateUI() {
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        
        self.totalItemsLabel.text = "Items Left: \(self.shoppingItems.count)"
        
        self.totalPriceLabel.text = "Total Price: \(currency) \(String(format: "%.2f", self.totalPrice!))"
        self.tableView.reloadData()
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemToSearchSeg" {
            
            let vc = segue.destination as! SearchItemViewController
            
            vc.shoppingList = shoppingList
        }
        
    }
    
    //MARK: SearchItemViewControllerDelegate
    
    func didChooseItem(groceryItem: GroceryItem) {
        
        let shopingItem = ShoppingItem(groceryItem: groceryItem)
        shopingItem.shoppingListId = shoppingList.id
        
        shopingItem.saveItemInBackground(shoppingItem: shopingItem) { (error) in
            
            
        }
    }
    
    
    
    //MARK: SwipeTableviewCell delegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var item: ShoppingItem!
        
        if indexPath.section == 0 {
            
            item = self.shoppingItems[indexPath.row]
        } else {
            
            item = self.boughtItems[indexPath.row]
        }
        
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            
            
            let buyItem = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                item.isBought = !item.isBought
                item.updateItemInBackground(shoppingItem: item, completion: { (error) in
                    
                    if error != nil {
                        
                        KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                        
                        return
                    }
                    
                })
                
                if indexPath.section == 0 {
                    
                    self.shoppingItems.remove(at: indexPath.row)
                    self.boughtItems.append(item)
                    
                } else {
                    
                    self.boughtItems.remove(at: indexPath.row)
                    self.shoppingItems.append(item)
                    
                }
                
                tableView.reloadData()
                
            }
            
            buyItem.accessibilityLabel = item.isBought ? "Buy" : "Return"
            
            let descriptor: ActionDescriptor = item.isBought ? .returnPurchase : .buy
            
            configure(action: buyItem, with: descriptor)
            
            
            return [buyItem]
        } else {
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                
                
                if indexPath.section == 0 {
                    
                    self.shoppingItems.remove(at: indexPath.row)
                } else {
                    
                    self.boughtItems.remove(at: indexPath.row)
                }
                
                item.deleteItemInBackground(shoppingItem: item)
                
                
                // Coordinate table view update animations
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
            }
            
            
            configure(action: delete, with: .trash)
            
            return [delete]
            
        }
        
        
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
    
    func culculateTotal() {
        
        self.totalPrice = 0
        
        for item in boughtItems {
            
            self.totalPrice = totalPrice + item.price
        }
        
        for item in shoppingItems {
            
            self.totalPrice = totalPrice + item.price
        }
        
        
        self.totalPriceLabel.text = "Total Price: \(String(format: "%.2f", self.totalPrice!))"
        
        //update shopping list totals
        shoppingList.totalPrice = self.totalPrice
        shoppingList.totalItems = self.boughtItems.count + self.shoppingItems.count
        
        shoppingList.updateItemInBackground(shoppingList: shoppingList) { (error) in
            
            if error != nil {
                
                KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                
                return
            }
          
            
        }
        shoppingList.updateItemad(shoppingList: shoppingList) { (error) in
            
            if error != nil {
                
                KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                
                return
            }
            
            
        }
        
    }
    
    func titleViewForTable(titleText: String) -> UIView {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.white
        view.addSubview(titleLabel)
        
        return view
    }
    
    
}
