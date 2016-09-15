//
//  DataManager.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import RealmSwift

class Token: Object {
    dynamic var accessToken = ""
}

class IndexedObject: Object {
    dynamic var id: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Shot: IndexedObject {
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var liked: Bool = false
    dynamic var created: NSDate?
    dynamic var images: Images?
    dynamic var user: User?
}

class User: IndexedObject {
    dynamic var name: String = ""
    dynamic var username: String = ""
    dynamic var title: String = ""
    dynamic var bio: String = ""
    dynamic var location: String = ""
    dynamic var avatar_url: String?
    dynamic var followers_count: Int = 0
    dynamic var likes_count: Int = 0
    dynamic var likes_received_count: Int = 0
    dynamic var shots_count: Int = 0
}

class Images: IndexedObject {
    dynamic var hidpi: String = ""
    dynamic var normal: String = ""
    dynamic var teaser: String = ""
}

class Comment: IndexedObject {
    dynamic var shotID: Int = 0
    dynamic var body: String = ""
    dynamic var created: NSDate?
    dynamic var user: User?
}

class Like: IndexedObject {
    dynamic var likedUserID: Int = 0
    dynamic var created: NSDate?
    dynamic var shot: Shot?
}

class Follower: IndexedObject {
    dynamic var followedUserID: Int = 0
    dynamic var user: User?
}

class DataManager {
    
    static let sharedInstance = DataManager()
    
    let realm = try! Realm()
    
    private var connectionManager: ConnectionManager? = nil
    
    private init(){
        connectionManager = ConnectionManager(withSavedToken: savedToken)
    }
        
    //Auth methods
    var authURL: NSURL? {
        get{
            return connectionManager?.loginURL
        }
    }
    
    func processFirstStepResponseURL(responseURL: NSURL, completion:VoidFunction) {
        
        connectionManager?.processFirstStepResponseURL(responseURL) { (result) in
            if let value = result {
                let serializer = Serializer(responseValue: value)
                
                let token = serializer.responseAuthToken()
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateToken(token)
                
                completion()
            }
        }
    }
    
    //Token methods
    private var savedToken: String? {
        get{
            if let token = realm.objects(Token).first {
                //            print("Saved token: \(token.accessToken)")
                return token.accessToken
            }
//            print("No token in DB")
            return nil
        }
    }
    
    var hasToken: Bool! {
        
        guard let token = savedToken else{
            return false
        }
        
        return !token.isEmpty
    }
    
    func updateToken(token: String?) {
        
        guard let newTokenString = token else{
            return
        }
        
        if let tokenObject = realm.objects(Token).first {
            try! realm.write {
                tokenObject.accessToken = newTokenString
            }
        }else{
            
            let newTokenObject = Token()
            newTokenObject.accessToken = newTokenString
            
            try! realm.write {
                realm.add(newTokenObject)
            }
        }
        
        connectionManager?.setNewToken(newTokenString)        
    }
    
    func clearToken() {
        if let tokenObject = realm.objects(Token).first {
            try! realm.write {
                realm.delete(tokenObject)
            }
        }
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.checkToken()
        }
    }
    
    //Shot methods
    func savedShots() -> [Shot] {
        
        let results = realm.objects(Shot).sorted("created", ascending: false)
        
        var shots: [Shot] = []
        
        for shot in results {

            shots.append(shot)
        }
        
        return shots
    }
    
    func fetchShots(completion:VoidFunction){
        
        let objectsSaved = realm.objects(Shot)
        
        let page = Int(floor(Double(objectsSaved.count)/100))
        
        connectionManager?.fetchShots("\(page)"){ (result) in
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let shots = serializer.responseShots()
                
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateShots(shots)
                
                completion()
            }
        }
    }
    
    private func updateShots(shots:[Shot]) {
        
        for shot in shots{
            
            try! realm.write {
                realm.add(shot, update: true)
            }
        }
    }
    
    func shotLikeAction(action: HTTPMehod, shotID: Int, completion:() ->()){
        
        connectionManager?.shotLikeAction(action, shotID: shotID) { (result) in
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let dataManager = DataManager.sharedInstance
                
                let liked = serializer.responseShotHasLikeDate()
                
                dataManager.updateShotLikeByID(shotID, liked: liked)
                
                completion()
            }
        }
    }
    
    private func updateShotLikeByID(shotID: Int, liked: Bool) {
        
        let shots = realm.objects(Shot).filter{$0.id == shotID}
        
        if let shot = shots.first {
            try! realm.write {
                shot.liked = liked
            }
        }
    }
    
    //Comments methods
    func savedComments(shotID: Int) -> [Comment] {
        
        let results = realm.objects(Comment).sorted("created", ascending: false).filter{$0.shotID == shotID}
        
        var comments: [Comment] = []
        
        for comment in results {
            
            comments.append(comment)
        }
        
        return comments
    }
    
    func commentsAction(action: HTTPMehod, shotID: Int, body: String?, completion:() ->()) {
        
        var page: String? = nil
        if action == HTTPMehod.GET {
            let objectsSaved = realm.objects(Comment)
            
            page = "\(Int(floor(Double(objectsSaved.count)/100)))"
        }
                
        connectionManager?.shotCommentAction(action, shotID: shotID, body: body, page: page){ (result) in
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let comments = serializer.responseComments(forShotID: shotID)
                
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateComments(comments)
                
            }
            
            completion()

        }
    }
    
    private func updateComments(comments:[Comment]) {
        
        for comment in comments{
            
            try! realm.write {
                realm.add(comment, update: true)
            }
        }
    }
    
    //Followers methods
    func savedFollowersForUser(userID: Int) -> [Follower] {
        
        let results = realm.objects(Follower).filter{$0.followedUserID == userID}
        
        var followers: [Follower] = []
        
        for follower in results {
            followers.append(follower)
        }
        
        return followers
    }
    
    func fetchFollowersForUser(userID: Int, completion:() ->()) {
        
        let followersSaved = realm.objects(Follower)
        
        let page = Int(floor(Double(followersSaved.count)/100))
        
        connectionManager?.fetchFollowersForUser(userID, page: "\(page)") { (result) in
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let followers = serializer.responseFollowers(forUserID: userID)
                
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateFollowers(followers)
                
            }
            
            completion()
        }
    }
    
    private func updateFollowers(followers:[Follower]) {
        
        for follower in followers{
            
            try! realm.write {
                realm.add(follower, update: true)
            }
        }
    }
    
    //Likes methods
    func savedLikesForUser(userID: Int) -> [Like] {
        
        let results = realm.objects(Like).filter{$0.likedUserID == userID}
        
        var likes: [Like] = []
        
        for like in results {
            likes.append(like)
        }
        
        return likes
    }
    
    func fetchLikesForUser(userID: Int, completion:() ->()) {
        
        let objectsSaved = realm.objects(Like)
        
        let page = Int(floor(Double(objectsSaved.count)/100))
        
        connectionManager?.fetchLikesForUser(userID, page: "\(page)") { (result) in
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let likes = serializer.responseLikes(forUserID: userID)
                
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateLikes(likes)
                
            }
            
            completion()
        }
    }
    
    private func updateLikes(likes:[Like]) {
        
        for like in likes{
            
            try! realm.write {
                realm.add(like, update: true)
            }
        }
    }
}