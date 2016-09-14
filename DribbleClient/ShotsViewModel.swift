//
//  ShotsViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class ShotsViewModel {
    
    private let dataManager = DataManager.sharedInstance
    
    private var cellsModels: [ShotsTableViewCellViewModel]! {
        get{
            
            let shots = dataManager.savedShots()
            
            var shotViewModels: [ShotsTableViewCellViewModel] = []
            
            for shot in shots {
                let newModel = ShotsTableViewCellViewModel(withShot: shot)
                shotViewModels.append(newModel)
            }
            
            return shotViewModels
        }
    }
    
    func numberOfShots() -> Int {
        return cellsModels.count
    }
    
    func cellViewModel(atIndex index: Int) -> ShotsTableViewCellViewModel? {
        
        guard index < cellsModels.count else {
            return nil
        }
        
        return cellsModels[index]
    }
    
    func updateShots(completion: () -> ()) {
        
        dataManager.fetchShots(){
            completion()
        }
    }
    
    var logoutFunction:()->()!{
        get{
            return logout
        }
    }
    
    private func logout() {
        dataManager.clearToken()
    }
}