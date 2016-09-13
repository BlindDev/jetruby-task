//
//  ShotsTableViewCellViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 12.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class ShotsTableViewCellViewModel {

    var shot: Shot
    
    init(withShot shot: Shot){
        self.shot = shot
    }
    
    func checkLike(completion:()->()) {
        
        ConnectionManager.sharedInstance.ckeckShotLike(shot.id) { (liked) in
            //TODO: add checking database instead
            
            completion()
        }
    }
}