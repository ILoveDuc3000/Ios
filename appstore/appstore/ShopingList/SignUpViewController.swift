//
//  SignUpViewController.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import KRProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var signInOutlet: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInOutlet.layer.cornerRadius = 8
        signInOutlet.layer.borderWidth = 1
        signInOutlet.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        signUpOutlet.layer.cornerRadius = 8
        signUpOutlet.layer.borderWidth = 1
        signUpOutlet.layer.borderColor = #colorLiteral(red: 0.1987636381, green: 0.7771705055, blue: 1, alpha: 1).cgColor
    }

    
    //MARK: IBActions

    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
      
        KRProgressHUD.show(message: "Signing up...")

        if emailTextField.text != "" && passwordTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {

            FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!) { (error) in
                
                if error != nil {
                    
                    KRProgressHUD.showWarning(message: error!.localizedDescription)
                    return
                }
                let shoppingList = ShoppingList(_name: self.lastNameTextField.text!)
                
                shoppingList.saveItemInBackground(shoppingList: shoppingList, completion: { (error) in
                    
                    if error != nil {
                        
                        KRProgressHUD.showWarning(message: "\(error!.localizedDescription)")
                        return
                    }
                    
                })

                self.goToApp()
                
            }
            
        } else {
            
            KRProgressHUD.showWarning(message: "All fields are required!")

        }
        
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Helper functions
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }


}
