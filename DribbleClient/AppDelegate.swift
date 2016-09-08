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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        ConnectionsManager.sharedInstance.processFirstStepResponse(url)
        
        return true
    }
}

