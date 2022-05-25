//
//  GroceryItem.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import Foundation

class GroceryItem {
    
    var name: String
    var info: String
    var price: Float
    let ownerId: String
    var image: String
    var groceryItemId: String
   
    
    init(_name: String, _info: String = "", _price: Float, _image: String = "",_quantity: String) {
        
        self.name = _name
        self.info = _info
        self.price = _price
        self.ownerId = FUser.currentId()
        self.image = _image
        self.groceryItemId = ""
      
    }

    
    init(dictionary: NSDictionary) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.price = dictionary[kPRICE] as! Float
        self.ownerId = dictionary[kOWNERID] as! String
        self.image = dictionary[kIMAGE] as! String
        self.groceryItemId = dictionary[kGROCERYITEMID] as! String
        
    }
    
    init(shoppingItem: ShoppingItem) {
        
        self.name = shoppingItem.name
        self.info = shoppingItem.info
        self.price = shoppingItem.price
        self.ownerId = FUser.currentId()
        self.image = shoppingItem.image
        self.groceryItemId = ""

    }
    
    func dictionaryFromItem(item: GroceryItem) -> NSDictionary {
        
        return NSDictionary(objects: [item.name, item.info, item.price, item.ownerId, item.image, item.groceryItemId], forKeys: [kNAME as NSCopying, kINFO as NSCopying, kPRICE as NSCopying, kOWNERID as NSCopying, kIMAGE as NSCopying, kGROCERYITEMID as NSCopying])
    }
    
    
    func saveItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kGROCERYITEM).childByAutoId()
        
        groceryItem.groceryItemId = ref.key
        
        
        ref.setValue(dictionaryFromItem(item: groceryItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
    
    func updateItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kGROCERYITEM).child(groceryItem.groceryItemId)
        
        ref.setValue(dictionaryFromItem(item: groceryItem)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
    func deleteItemInBackground(groceryItem: GroceryItem) {
        
        let ref = firebase.child(kGROCERYITEM).child(groceryItem.groceryItemId)
        ref.removeValue()
        
    }
    
    
}
