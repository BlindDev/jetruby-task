//
//  AppDelegate.swift
//  DribbleClient
//
//  Created by Pavel Popov on 08.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let dataManager = DataManager.sharedInstance
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = StyleKit.pinkColor
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBarAppearace.titleTextAttributes = titleDict as? [String : AnyObject]
        
        UINavigationBar.appearance().barStyle = .Black
        
        checkToken()
        
        return true
    }
    
    func checkToken(){
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        if dataManager.hasToken == false {
            
            if let loginViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                
                let loginViewModel = LoginViewModel(withAuthURL: dataManager.authURL)
                
                loginViewController.viewModel = loginViewModel
                
                window?.rootViewController = loginViewController
            }
            
        }else{
            if let navController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("RootNavigationController") as? UINavigationController {
                
                if let shotsController = navController.viewControllers.first as? ShotsViewController {
                    shotsController.viewModel = ShotsViewModel()
                }
                
                window?.rootViewController = navController
            }
        }
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
//        print("Handle URL: \(url)")
        dataManager.processFirstStepResponseURL(url){
            self.checkToken()
        }
        
        return true
    }
}

