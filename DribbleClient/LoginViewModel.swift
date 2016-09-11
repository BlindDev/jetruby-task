//
//  LoginViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    var hasToken: Bool!
    
    let connectionManager = ConnectionManager.sharedInstance
    
    required init(withTokenStatus status: Bool) {
        
        self.hasToken = status
    }
    
    func authURL() -> NSURL? {
        
        return connectionManager.loginURL
    }
}

