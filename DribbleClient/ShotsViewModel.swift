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
    
    private let dataManager = DataManager.sharedInstance
    
    var delegate: ShotsViewModelDelegate?
    
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
    
    init(){
        dataManager.delegate = self
    }
    
    func hasToken() -> Bool {
        
        return dataManager.hasToken
    }
    
    func loginURL() -> NSURL? {
        return dataManager.authURL
    }
    
    func updateShots(completion: () -> ()) {
        
        dataManager.fetchShots(){
            self.checkShots(completion)
        }
    }
    
    func checkShots(completion: () -> ()) {
        let shots = dataManager.savedShots()
        
        for shot in shots {
            let newModel = ShotsTableViewCellViewModel(withShot: shot)
            self.cellsModels.append(newModel)
        }
        completion()
    }
    
    func logout() {
        dataManager.clearToken()
    }
}

extension ShotsViewModel: DataManagerDelegate {
    
    func tokenDidSet() {
        delegate?.didEndAuth(hasToken())
    }
}