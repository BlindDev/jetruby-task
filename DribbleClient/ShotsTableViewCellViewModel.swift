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
    
    var shotLiked: Bool!{
        get{
            return shot.liked
        }
    }
    
    var shotID: Int!{
        get{
            return shot.id
        }
    }
    
    var shotDescription: String!{
        get{
            
//            print(shot.created)
            return shot.desc.withoutHTML
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
    
    
    func shotLikeAction(action: HTTPMehod, completion:(result: Bool)->()) {
        
        DataManager.sharedInstance.shotLikeAction(action, shotID: shot.id) {
            completion(result: self.shotLiked)
        }
    }
}