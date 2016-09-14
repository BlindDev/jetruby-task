//
//  CommentsViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class CommentsViewModel {
    private var shotID: Int
    
    init(withShotID id: Int){
        self.shotID = id
    }
    
    func updateComments(completion: () -> ()) {
        
        //TODO: add checking offline and checking database
        
//        ConnectionManager.sharedInstance.fetchShots(){ (savedShots) in
//            
//            self.cellsModels.removeAll()
//            
//            for shot in savedShots {
//                let newModel = ShotsTableViewCellViewModel(withShot: shot)
//                self.cellsModels.append(newModel)
//            }
//            completion()
//        }
    }
    
    func checkComments(completion: () -> ()) {
//        let shots = dataManager.savedShots()
//        
//        for shot in shots {
//            let newModel = ShotsTableViewCellViewModel(withShot: shot)
//            self.cellsModels.append(newModel)
//        }
        completion()
    }
}