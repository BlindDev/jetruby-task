//
//  ListCellModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 15.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class ListCellModel {
    
    private var follower: Follower!
    
    init(withFollower follower: Follower) {
        self.follower = follower
    }
    
    private var like: Like!
    
    init(withLike like: Like){
        self.like = like
    }
    
    var userName: String! {
        guard let user = follower.user else{
            return ""
        }
        return user.name
    }
    
    var avatarLink: String! {
        
        guard let user = follower.user else{
            return ""
        }
        
        guard let link = user.avatar_url else{
            return ""
        }
        return link
    }
    
    var detailText: String!{
        
        guard let user = follower.user else{
            return ""
        }
        
        if like != nil {
            return "Likes \(user.likes_count)"
        }else{
            return likeDetail()
        }
    }
    
    private func likeDetail() -> String {
        
        guard let createdDate = like.created else{
            return ""
        }
        
        let created = "Created " + createdDate.convertedString
        
        guard let shot = like.shot else{
            return created
        }
        
        return created + " for Shot ID: \(shot.id)"
    }
}