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
    
    required init(withTokenStatus status: Bool) {
        
        self.hasToken = status
        
        let manager = DataManager.sharedInstance
        manager.delegate = self
    }
}

extension LoginViewModel: LoginViewDelegate {
    func authenticate() {
        let connectionManager = ConnectionManager.sharedInstance
        
        connectionManager.startLogin()
    }
}

extension LoginViewModel: DataManagerDelegate {
    
    func tokenDidSet() {
        print("Token did set")
        
        //TODO: remove login view
    }
}