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
                
                shots.append(responseShot(fromJSON: shot))
            }
        
        }
        
        return shots
    }
    
    func responseComments(forShotID shotID: Int) -> [Comment] {
        
        guard let commentsArray = json?.array else{
            return []
        }
        
        var comments: [Comment]! = []
        
        for comment in commentsArray {
            
            let newComment = Comment()
            
            newComment.shotID = shotID
            
            if let id = comment["id"].int {
                newComment.id = id
            }
            
            if let body = comment["body"].string {
                newComment.body = body
            }
            
            if let createdString = comment["created_at"].string {
                newComment.created = createdString.convertedDate
            }
            
            newComment.user = responseUser(fromJSON: comment["user"])
            
            comments.append(newComment)
        }
        
        return comments
    }
    
    func responseFollowers(forUserID userID: Int) -> [Follower] {
        
        guard let followersArray = json?.array else{
            return []
        }
        
        var followers: [Follower]! = []
        
        for follower in followersArray {
            
            let newFollower = Follower()
            newFollower.followedUserID = userID
            
            if let id = follower["id"].int {
                newFollower.id = id
            }
            
            newFollower.user = responseUser(fromJSON: follower["follower"])
            
            followers.append(newFollower)
        }
        
        return followers
    }
    
    func responseLikes(forUserID userID: Int) -> [Like] {
        
        guard let likesArray = json?.array else{
            return []
        }
        
        var likes: [Like]! = []
        
        for like in likesArray {
            
            let newLike = Like()
            newLike.likedUserID = userID
            
            if let id = like["id"].int {
                newLike.id = id
            }
            
            newLike.shot = responseShot(fromJSON: like["shot"])
            
            likes.append(newLike)
        }
        
        return likes
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
        
        if let likes_received_count = json["likes_received_count"].int {
            newUser.likes_received_count = likes_received_count
        }
        
        if let shots_count = json["shots_count"].int {
            newUser.shots_count = shots_count
        }
        
        return newUser
    }
    
    private func responseShot(fromJSON json: JSON) -> Shot {
        let newShot = Shot()
        
        if let id = json["id"].int {
            newShot.id = id
        }
        
        if let title = json["title"].string {
            newShot.title = title
        }
        
        if let desc = json["description"].string{
            newShot.desc = desc
        }
        
        if let createdString = json["created_at"].string {
            newShot.created = createdString.convertedDate
        }
        
        let newImages = Images()
        newImages.id = newShot.id
        
        if let hidpi = json["images"]["hidpi"].string {
            newImages.hidpi = hidpi
        }
        
        if let normal = json["images"]["normal"].string {
            newImages.normal = normal
        }
        
        if let teaser = json["images"]["teaser"].string {
            newImages.teaser = teaser
        }
        
        newShot.images = newImages
        
        newShot.user = responseUser(fromJSON: json["user"])

        return newShot
    }
}