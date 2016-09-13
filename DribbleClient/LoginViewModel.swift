//
//  LoginViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    func authURL() -> NSURL? {
        return ConnectionManager.sharedInstance.loginURL
    }
}

