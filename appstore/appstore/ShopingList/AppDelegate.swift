//
//  AppDelegate.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//




import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firstLoad: Bool?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        setNavBar()

        loadUserDefaults()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil {
                
                if userDefaults.object(forKey: kCURRENTUSER) != nil {
                    
                    self.goToApp()
                    
                }
                
            }
        }

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    
    func loadUserDefaults() {
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            
            userDefaults.set(true, forKey: kFIRSTRUN)
            
            userDefaults.set("€", forKey: kCURRENCY)
            userDefaults.synchronize()
            
        }
    }

    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
    }
    
    func setNavBar() {
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1987636381, green: 0.7771705055, blue: 1, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]

    }

}

