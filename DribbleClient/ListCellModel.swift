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
    
    private var user: User?
    
    init(withFollower follower: Follower) {
        self.follower = follower
        self.user = follower.user
    }
    
    private var like: Like!
    
    init(withLike like: Like){
        self.like = like
        self.user = like.shot?.user
    }
    
    var userName: String! {
        guard let currentUser = user else{
            return ""
        }
        
        return currentUser.name
    }
    
    var avatarLink: String! {
        
        guard let currentUser = user else{
            return ""
        }
        
        guard let link = currentUser.avatar_url else{
            return ""
        }
        return link
    }
    
    var detailText: String!{
        
        guard let currentUser = user else{
            return ""
        }
        
        if like == nil {
            return "Likes \(currentUser.likes_count)"
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