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
        // Override point for customization after application launch.
        
        if let navController = self.window?.rootViewController as? UINavigationController {
            
            if let shotsController = navController.viewControllers.first as? ShotsViewController {
                shotsController.viewModel = ShotsViewModel(withToken: dataManager.savedToken())
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
//        print("Handle URL: \(url)")
        ConnectionManager.sharedInstance.processFirstStepResponse(url)
        
        return true
    }
}

