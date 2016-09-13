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
        
        print("Serialized like \(json)")
        
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
            
            if let hidpi = shot["images"]["hidpi"].string {
                newImages.hidpi = hidpi
            }
            
            if let normal = shot["images"]["normal"].string {
                newImages.hidpi = normal
            }
            
            if let teaser = shot["images"]["teaser"].string {
                newImages.hidpi = teaser
            }
            
            newShot.images = newImages
            
            let newUser = User()
            
            if let userID = shot["user"]["id"].int {
                newUser.id = userID
            }
            
            if let name = shot["user"]["name"].string {
                newUser.name = name
            }
            
            if let username = shot["user"]["username"].string {
                newUser.username = username
            }
            
            if let title = shot["user"]["title"].string {
                newUser.title = title
            }
            
            if let bio = shot["user"]["bio"].string {
                newUser.bio = bio
            }
            
            if let location = shot["user"]["location"].string {
                newUser.location = location
            }
            
            if let followers_count = shot["user"]["followers_count"].int {
                newUser.followers_count = followers_count
            }
            
            if let likes_count = shot["user"]["likes_count"].int {
                newUser.likes_count = likes_count
            }
            
            if let shots_count = shot["user"]["shots_count"].int {
                newUser.shots_count = shots_count
            }
            
            newShot.user = newUser
            
            shots.append(newShot)
        }
        
        return shots
    }
}