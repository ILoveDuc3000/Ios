//
//  ShopingItem.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import Foundation

class ShoppingItem {
    
    var name: String
    var info: String
    var quantity: String
    var price: Float
    var shoppingItemId: String
    var shoppingListId: String
    var isBought: Bool
    var image: String
   
    
    init(_name: String, _info: String = "", _quantity: String = "1", _price: Float, _shoppingListId: String, _shoppingItemId: String = "") {
        
        self.name = _name
        self.info = _info
        self.quantity = _quantity
        self.price = _price
        self.shoppingListId = _shoppingListId
        self.shoppingItemId = _shoppingItemId
        self.isBought = false
        self.image = ""
    }
    
    init(dictionary: NSDictionary) {
        
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.quantity = dictionary[kQUANTITY] as! String
        self.price = dictionary[kPRICE] as! Float
        self.shoppingItemId = dictionary[kSHOPPINGITEMID] as! String
        self.shoppingListId = dictionary[kSHOPPINGLISTID] as! String
        self.isBought = dictionary[kISBOUGHT] as! Bool
        self.image = dictionary[kIMAGE] as! String

    }
    
    init(groceryItem: GroceryItem) {
        
        self.name = groceryItem.name
        self.info = groceryItem.info
        self.quantity = "1"
        self.price = groceryItem.price
        self.shoppingListId = ""
        self.shoppingItemId = ""
        self.isBought = false
        self.image = groceryItem.image

    }
    
    func dictionaryFromItem(item: ShoppingItem) -> NSDictionary {
        
        return NSDictionary(objects: [item.name, item.info, item.quantity, item.price, item.shoppingListId, item.shoppingItemId, item.isBought, item.image], forKeys: [kNAME as NSCopying, kINFO as NSCopying, kQUANTITY as NSCopying, kPRICE as NSCopying, kSHOPPINGLISTID as NSCopying, kSHOPPINGITEMID as NSCopying, kISBOUGHT as NSCopying, kIMAGE as NSCopying])
    }
    
    
    func saveItemInBackground(shoppingItem: ShoppingItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).childByAutoId()
        
        shoppingItem.shoppingItemId = ref.key
        
        
        ref.setValue(dictionaryFromItem(item: shoppingItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
   


    
    func updateItemInBackground(shoppingItem: ShoppingItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        
        ref.setValue(dictionaryFromItem(item: shoppingItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
    func deleteItemInBackground(shoppingItem: ShoppingItem) {
        
        let ref = firebase.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        ref.removeValue()
        
    }

    
    class func deleteAllShoppingItemsOfTheList(shoppingList: ShoppingList, completion: @escaping (_ success: Bool) -> Void) {
        
        firebase.child(kSHOPPINGITEM).child(shoppingList.id).removeValue { (error, ref) in
            
            if error != nil {
                print("Error deleting all shopping Items\(error!.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
            
        }
        
    }
    class func deleteAllShoppingItemsOfTheListad(shoppingList: ShoppingList, completion: @escaping (_ success: Bool) -> Void) {
        
        firebase.child(KLIST).child(shoppingList.id).removeValue { (error, ref) in
            
            if error != nil {
                print("Error deleting all shopping Items\(error!.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
            
        }
        
    }
    
   

    
}
