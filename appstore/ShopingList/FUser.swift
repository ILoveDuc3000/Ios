//
//  FUser.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import KRProgressHUD

class FUser {
    
    let objectId: String
    
    let createdAt: Date
    
    var email: String
    var firstname: String
    var lastname: String
    var fullname: String
    
    
    //MARK: Initializers
    
    init(_objectId: String, _createdAt: Date, _email: String, _firstname: String, _lastname: String) {
        
        objectId = _objectId
        
        createdAt = _createdAt
        
        email = _email
        firstname = _firstname
        lastname = _lastname
        fullname = _firstname + " " + _lastname
        
    }
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as! String
        
        createdAt = dateFormatter().date(from: _dictionary[kCREATEDAT] as! String)!
        
        email = _dictionary[kEMAIL] as! String
        firstname = _dictionary[kFIRSTNAME] as! String
        lastname = _dictionary[kLASTNAME] as! String
        fullname = firstname + " " + lastname
        
    }
    
    
    //MARK: Returning current user funcs
    
    class func currentId() -> String {
        
        return FIRAuth.auth()!.currentUser!.uid
        
    }
    
    class func currentUser () -> FUser? {
        
        if FIRAuth.auth()!.currentUser != nil {
            
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
        
    }
    
  
    
    //MARK: Login function
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            fetchUser(userId: firUser!.uid, withBlock: { (success) in
                
            })

            
            completion(error)

        })
        
    }
    
    //MARK: Register functions
    
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firuser, error) in
            
            if error != nil {
                
                completion(error)
                return
            }
            
            
            let fUser = FUser(_objectId: firuser!.uid, _createdAt: Date(), _email: firuser!.email!, _firstname: firstName, _lastname: lastName)
            
            saveUserLocally(fUser: fUser)
            saveUserInBackground(fUser: fUser)
            completion(error)
        })
        
    }
    
    
    //MARK: LogOut func
    
    class func logOutCurrentUser(withBlock: @escaping (_ success: Bool) -> Void) {
        
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            
            try FIRAuth.auth()?.signOut()
            
            
            withBlock(true)
            
        } catch let error as NSError {
            withBlock(false)
            print(error.localizedDescription)
            
        }
        
        
    }
    
} //end of class funcs




//MARK: Save user funcs

func saveUserInBackground(fUser: FUser) {
    
    let ref = firebase.child(kUSER).child(fUser.objectId)
    
    ref.setValue(userDictionaryFrom(user: fUser))
    
}


func saveUserLocally(fUser: FUser) {
    
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: Fetch User funcs

 func fetchUser(userId: String, withBlock: @escaping (_ success: Bool) -> Void) {
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observe(.value, with: {
        snapshot in
        
        if snapshot.exists() {
            
            let user = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! NSDictionary
            
            
            userDefaults.setValue(user, forKeyPath: kCURRENTUSER)
            userDefaults.synchronize()
            
            withBlock(true)
            
        } else {
            
            withBlock(false)
        }
        
    })
    
}


//MARK: Helper funcs

func userDictionaryFrom(user: FUser) -> NSDictionary {
    
    let createdAt = dateFormatter().string(from: user.createdAt)
    
    return NSDictionary(objects: [user.objectId,  createdAt, user.email, user.firstname, user.lastname, user.fullname], forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying])
    
}

func cleanupFirebaseObservers() {
    
    firebase.child(kUSER).removeAllObservers()
    firebase.child(kSHOPPINGLIST).removeAllObservers()
    firebase.child(kSHOPPINGITEM).removeAllObservers()
    firebase.child(kGROCERYITEM).removeAllObservers()
}


//MARK: Update current user funcs

func resetUserPassword(email: String) {
    
    FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
        
        if error != nil {
            
            KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")

        } else {
            
            KRProgressHUD.showSuccess(message: "Password reset email sent!")
        }
        
    })
}






