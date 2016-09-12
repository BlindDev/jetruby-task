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
    
    private var token: String?
    
    private var cellsModels = [ShotsTableViewCellViewModel]()
    
    func numberOfShots() -> Int {
        return cellsModels.count
    }
    
    func cellViewModel(atIndex index: Int) -> ShotsTableViewCellViewModel? {
        
        guard index < cellsModels.count else {
            return nil
        }
        
        return cellsModels[index]
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
        
        if let currentToken = token {
            connectionManager.fetchShots(withToken: currentToken){ (savedShots) in
                
                self.cellsModels.removeAll()
                
                for shot in savedShots {
                    let newModel = ShotsTableViewCellViewModel(withShot: shot)
                    self.cellsModels.append(newModel)
                }
                completion()
            }
        }
    }
    
    func logout() {
        token = nil
        dataManager.clearToken()
    }
}

extension ShotsViewModel: DataManagerDelegate {
    
    func tokenNewValue(token: String?) {
        self.token = token
        
        delegate?.didEndAuth(hasToken())
    }
}