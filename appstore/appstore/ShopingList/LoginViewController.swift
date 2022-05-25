//
//  LoginViewController.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import KRProgressHUD

class LoginViewController: UIViewController {
    
    var login = true
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButtonOutlet.layer.cornerRadius = 8
        signUpButtonOutlet.layer.borderWidth = 1
        signUpButtonOutlet.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        signInButtonOutlet.layer.cornerRadius = 8
        signInButtonOutlet.layer.borderWidth = 1
        signInButtonOutlet.layer.borderColor = #colorLiteral(red: 0.1987636381, green: 0.7771705055, blue: 1, alpha: 1).cgColor
    }
    
    
    //MARK: IBActions
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            KRProgressHUD.show(message: "Signing in...")
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!, completion: { (error) in
                
                if error != nil {
                    
                    KRProgressHUD.showError(message: "\(error!.localizedDescription)")
                    
                    return
                }
                
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.view.endEditing(false)
                
                self.goToApp()
                
                
            })
            
        } else {
            
            KRProgressHUD.showWarning(message: "  Login credentials are empty!  ")
        }
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" {
            
            resetUserPassword(email: emailTextField.text!)
        } else {
            KRProgressHUD.showWarning(message: "Email is empty!")
        }
        
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(false)
    }
    
    //MARK: Helper functions
    
    func goToApp() {
       
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }
    
}
