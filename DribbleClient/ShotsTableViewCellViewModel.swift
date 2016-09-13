//
//  ShotsTableViewCellViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 12.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class ShotsTableViewCellViewModel {
    
    private var shot: Shot
    
    init(withShot shot: Shot){
        self.shot = shot
    }
    
    var shotTitle: String!{
        get{
            return shot.title
        }
    }
    
    var shotDescription: String!{
        get{
            return shot.desc
        }
    }
    
    var shotUsername: String!{
        get{
            
            if let userName = shot.user?.username {
                return userName
            }
            
            return ""
        }
    }
    
    var shotImageLink: String!{
        get{
            
            if let hidpi = shot.images?.hidpi {
                return hidpi
            }
            
            if let normal = shot.images?.normal {
                return normal
            }
            
            if let teaser = shot.images?.teaser {
                return teaser
            }
            
            return ""
        }
    }
    
    
    func shotLikeAction(action: ShotLikeAction, completion:(result: Bool)->()) {
        
        ConnectionManager.sharedInstance.shotLikeAction(action, shotID: shot.id) {
            //TODO: add checking database instead
            
            completion(result: self.shot.liked)
        }
    }
}