//
//  ShotsViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

protocol ShotsViewModelDelegate {
    func didEndAuth(success: Bool)

}

class ShotsViewModel {
    
    private let connectionManager = ConnectionManager.sharedInstance
    private let dataManager = DataManager.sharedInstance
    
    var delegate: ShotsViewModelDelegate?
    var token: String?
    
    var shots: [Shot]!{
        get{
            return dataManager.savedShots()
        }
    }
    
    init(withToken token: String?){
        
        self.token = token
        dataManager.delegate = self
    }
    
    func hasToken() -> Bool {
        
        if let currentToken = token {
            return !currentToken.isEmpty
        }
        
        return false
    }
    
    func updateShots(completion: () -> ()) {
        connectionManager.fetchShots(){
            completion()
        }
    }
    
    func logout() {
        dataManager.clearToken()
    }
}

extension ShotsViewModel: DataManagerDelegate {
    
    func tokenNewValue(token: String?) {
        self.token = token
        
        delegate?.didEndAuth(hasToken())
    }
}