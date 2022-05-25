//
//  AddShoppingItemViewController.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddShoppingItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var extraInfoTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var itemImageView: UIImageView!
    var itemImage: UIImage?
    
    var shoppingList: ShoppingList!
    var shoppingItem: ShoppingItem?
    var groceryItem: GroceryItem?
    
    var addingToList: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quantityTextField.delegate = self
        
        let image = UIImage(named: "ShoppingCartEmpty")
        itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
        
        
        if shoppingItem != nil || groceryItem != nil {
            updateUI()
        }
    }
    
    
    //MARK: IBActions
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = Camera(delegate_: self)
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert: UIAlertAction!) in
            
            camera.PresentPhotoLibrary(target: self, canEdit: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
            
        }
        
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if nameTextField.text != "" && priceTextField.text != "" {
            
            if shoppingItem != nil || groceryItem != nil {
                
                self.updateItem()
                
               
            } else {
                
                self.saveItem()
            }
        } else {
            
            KRProgressHUD.showWarning(message: "Empty fields!")
            
        }
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 1
        
        self.present(vc, animated: true, completion: nil)
        
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UpdateUI
    
    func updateUI() {
        
        if shoppingItem != nil {
            
            self.nameTextField.text = self.shoppingItem!.name
            self.extraInfoTextField.text = self.shoppingItem!.info
            self.quantityTextField.text = self.shoppingItem!.quantity
            self.priceTextField.text = "\(self.shoppingItem!.price)"
            
            if shoppingItem!.image != "" {
                imageFromData(pictureData: shoppingItem!.image, withBlock: { (image) in
                    
                    itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                    
                })
                
            }
            
        } else if groceryItem != nil {
            
            self.nameTextField.text = self.groceryItem!.name
            self.extraInfoTextField.text = self.groceryItem!.info
            self.quantityTextField.text = ""
            self.priceTextField.text = "\(self.groceryItem!.price)"
            
            if groceryItem!.image != "" {
                imageFromData(pictureData: groceryItem!.image, withBlock: { (image) in
                    
                    itemImageView.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                    
                })
                
            }
            
        }
        
    }
    
    
    //MARK: Saving
    
    func saveItem() {
        
        var shoppingItem: ShoppingItem
        
        var imageData: String!
        
        if itemImage != nil {
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)!
            imageData = image.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        } else {
            imageData = ""
        }
        
        if addingToList! {
            
            //add to groceryList only
            shoppingItem = ShoppingItem(_name: nameTextField.text!, _info: extraInfoTextField.text!, _price: Float(priceTextField.text!)!, _shoppingListId: "")
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            groceryItem.image = imageData
            
            groceryItem.saveItemInBackground(groceryItem: groceryItem) { (error) in
                
                if error != nil {
                    
                    KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                    
                    return
                }
                
                
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
            
            vc.selectedIndex = 1
            
            self.present(vc, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
            
            
        } else {
            
            //add to current item, give option to add to list as well?
            shoppingItem = ShoppingItem(_name: nameTextField.text!, _info: extraInfoTextField.text!, _quantity: quantityTextField.text!, _price: Float(priceTextField.text!)!, _shoppingListId: shoppingList.id)
            
            shoppingItem.image = imageData
            
            
            shoppingItem.saveItemInBackground(shoppingItem: shoppingItem, completion: { (error) in
                
                if error != nil {
                    
                    KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                    
                    return
                }
                
            })
            
            showListNotification(shoppingItem: shoppingItem)
            
        }
        
        
    }
    
    func showListNotification(shoppingItem: ShoppingItem) {
        
        let alertController = UIAlertController(title: "Shoppig Items", message: "Do you want to add this item to your items?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action: UIAlertAction!) in
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                
                if error != nil {
                    
                    print("Error creating grocery item from shopping item: \(error!.localizedDescription)")
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func updateItem() {
        
        var imageData: String!
        
        if itemImage != nil {
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)!
            imageData = image.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        } else {
            imageData = ""
        }
        
        
        if shoppingItem != nil {
            
            shoppingItem!.name = nameTextField.text!
            shoppingItem!.price = Float(priceTextField.text!)!
            shoppingItem!.quantity = quantityTextField.text!
            shoppingItem!.info = extraInfoTextField.text!
            
            shoppingItem!.image = imageData
            
            shoppingItem!.updateItemInBackground(shoppingItem: shoppingItem!) { (error) in
                
                if error != nil {
                    
                    KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                    
                    return
                }
                
            }
            
        } else
            if(FUser.currentId()==KADMIN){
                if groceryItem != nil {
                    
                    groceryItem!.name = nameTextField.text!
                    groceryItem!.price = Float(priceTextField.text!)!
                    groceryItem!.info = extraInfoTextField.text!
                    
                    groceryItem!.image = imageData
                    
                    groceryItem!.updateItemInBackground(groceryItem: groceryItem!) { (error) in
                        
                        if error != nil {
                            
                            KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                            
                            return
                        }
                        
                        
                    }
                }
        }
            else{
               KRProgressHUD.showWarning(message: "only admin can upadate")
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 1
        
        self.present(vc, animated: true, completion: nil)
        // self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 3
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    
    
    
    //MARK: UIIMagepickercontroller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.itemImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
        self.itemImageView.image = maskRoundedImage(image: itemImage!, radius: Float(itemImage!.size.width / 2))
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
