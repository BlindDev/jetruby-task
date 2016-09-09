//
//  ShotsViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

protocol ShotsViewModelDelegate {
    //TODO: add connection status
}

class ShotsViewModel {
    
    var token: String?
    
    private let connectionManager = ConnectionManager.sharedInstance
    
    init(withToken token: String?){
        
        self.token = token
    }
    
    func hasToken() -> Bool {
        
        if let currentToken = token {
            return !currentToken.isEmpty
        }
        
        return false
    }
}