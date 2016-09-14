//
//  JSONManager.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Serializer {
    
    private var json: JSON?
    
    init(responseValue value: AnyObject) {
        
        json = JSON(value)
    }
    
    func responseAuthToken() -> String? {
        
        guard let currentJSON = json else{
            return nil
        }

        guard let accessString = currentJSON["access_token"].string else{
            return nil
        }
        
        return accessString
    }
    
    func responseShotHasLikeDate() -> Bool {
                
        guard let dataString = json?["created_at"].string else{
            return false
        }
        
        return !dataString.isEmpty
    }
    
    func responseShots() ->[Shot] {
        
        guard let shotsArray = json?.array else{
            return []
        }
        
        var shots: [Shot]! = []
        
        for shot in shotsArray {
            
            if let animated = shot["animated"].bool where animated == false {
                
                let newShot = Shot()
                
                if let id = shot["id"].int {
                    newShot.id = id
                }
                
                if let title = shot["title"].string {
                    newShot.title = title
                }
                
                if let desc = shot["description"].string{
                    newShot.desc = desc
                }
                
                if let createdString = shot["created_at"].string {
                    newShot.created = createdString.convertedDate
                }
                
                let newImages = Images()
                newImages.id = newShot.id
                
                if let hidpi = shot["images"]["hidpi"].string {
                    newImages.hidpi = hidpi
                }
                
                if let normal = shot["images"]["normal"].string {
                    newImages.normal = normal
                }
                
                if let teaser = shot["images"]["teaser"].string {
                    newImages.teaser = teaser
                }
                
                newShot.images = newImages
                
                newShot.user = responseUser(fromJSON: shot["user"])
                
                shots.append(newShot)
            }
        
        }
        
        return shots
    }
    
    func responseComments() -> [Comment] {
        
        guard let commentsArray = json?.array else{
            return []
        }
        
        var comments: [Comment]! = []
        
        for comment in commentsArray {
            
            let newComment = Comment()
            
            if let id = comment["id"].int {
                newComment.id = id
            }
            
            if let createdString = comment["created_at"].string {
                newComment.created = createdString.convertedDate
            }
            
            newComment.user = responseUser(fromJSON: comment["user"])
            
            comments.append(newComment)
        }
        
        return comments
    }
    
    private func responseUser(fromJSON json: JSON) -> User {
        
        let newUser = User()
        
        if let userID = json["id"].int {
            newUser.id = userID
        }
        
        if let avatar_url = json["avatar_url"].string {
            newUser.avatar_url = avatar_url
        }
        
        if let name = json["name"].string {
            newUser.name = name
        }
        
        if let username = json["username"].string {
            newUser.username = username
        }
        
        if let title = json["title"].string {
            newUser.title = title
        }
        
        if let bio = json["bio"].string {
            newUser.bio = bio
        }
        
        if let location = json["location"].string {
            newUser.location = location
        }
        
        if let followers_count = json["followers_count"].int {
            newUser.followers_count = followers_count
        }
        
        if let likes_count = json["likes_count"].int {
            newUser.likes_count = likes_count
        }
        
        if let shots_count = json["shots_count"].int {
            newUser.shots_count = shots_count
        }
        
        return newUser
    }
}