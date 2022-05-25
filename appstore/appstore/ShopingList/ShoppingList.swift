//
//  ShopingList.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import Foundation
import Firebase

class ShoppingList {
    
    let name: String
    var totalPrice: Float
    var totalItems: Int
    var id: String
    var date: Date
    var ownerId: String
    
    init(_name: String, _totalPrice: Float = 0, _id: String = "") {
        
        self.name = _name
        self.totalPrice = _totalPrice
        self.id = _id
        self.date = Date()
        self.ownerId = FUser.currentId()
        self.totalItems = 0
    }
    
    init(dictionary: NSDictionary) {
        
        self.name = dictionary[kNAME] as! String
        self.totalPrice = dictionary[kTOTALPRICE] as! Float
        self.totalItems = dictionary[kTOTALITEMS] as! Int

        self.id = dictionary[kSHOPPINGLISTID] as! String
        self.date = dateFormatter().date(from: dictionary[kDATE] as! String)!
        self.ownerId = dictionary[kOWNERID] as! String
    }
    
    func dictionaryFromItem(item: ShoppingList) -> NSDictionary {

        return NSDictionary(objects: [item.name, item.totalPrice, item.totalItems, item.id, dateFormatter().string(from: item.date), item.ownerId], forKeys: [kNAME as NSCopying, kTOTALPRICE as NSCopying, kTOTALITEMS as NSCopying, kSHOPPINGLISTID as NSCopying, kDATE as NSCopying, kOWNERID as NSCopying])
    }
    

    func saveItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kSHOPPINGLIST).child(FUser.currentId()).childByAutoId()
        
        shoppingList.id = ref.key
        ref.setValue(dictionaryFromItem(item: shoppingList)) { (error, ref) -> Void in
            
            completion(error)
            
        }
       
        
        
    }
    func saveItemInad(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(KLIST).child(FUser.currentId())
        shoppingList.id = ref.key
        ref.setValue(dictionaryFromItem(item: shoppingList)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
        
        
    }
   
    
    func updateItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(kSHOPPINGLIST).child(FUser.currentId()).child(shoppingList.id)
 
        
        ref.setValue(dictionaryFromItem(item: shoppingList)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    func updateItemad(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void) {
        
        let ref = firebase.child(KLIST).child(shoppingList.id)
        
        
        ref.setValue(dictionaryFromItem(item: shoppingList)) { (error, ref) -> Void in
            
            completion(error)
            
        }
        
    }
    
    func deleteItemInBackground(shoppingList: ShoppingList) {
        
        let ref = firebase.child(kSHOPPINGLIST).child(FUser.currentId()).child(shoppingList.id)
        ref.removeValue()
        
    }
    func deleteItemad(shoppingList: ShoppingList) {
        
        let ref = firebase.child(KLIST).child(shoppingList.id)
        ref.removeValue()
        
    }

    
    
}
