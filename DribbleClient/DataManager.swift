//
//  DataManager.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import RealmSwift

protocol DataManagerDelegate {
    func tokenDidSet(success: Bool)
}

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
    dynamic var followers_count: Int = 0
    dynamic var likes_count: Int = 0
    dynamic var shots_count: Int = 0

}

class Images: Object {
    dynamic var hidpi: String = ""
    dynamic var normal: String = ""
    dynamic var teaser: String = ""
}

class DataManager {
    static let sharedInstance = DataManager()
    let realm = try! Realm()

    var delegate: DataManagerDelegate?
    
    func savedToken() -> String? {
        
        if let token = realm.objects(Token).first {
            print("Saved token: \(token.accessToken)")
            return token.accessToken
        }
        print("No token in DB")
        return nil
    }
    
    func updateToken(token: String?) {
                
        guard let newTokenString = token else{
            delegate?.tokenDidSet(false)
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
        
        delegate?.tokenDidSet(true)

    }
    
    func clearToken() {
        if let tokenObject = realm.objects(Token).first {
            try! realm.write {
                realm.delete(tokenObject)
            }
        }
    }
    
    func savedShots() -> [Shot] {
        
        let results = realm.objects(Shot).sorted("created", ascending: true)
        
        var shots: [Shot]!
        
        for shot in results {
            shots.append(shot)
        }
        
        return shots
    }
    
    func saveNewShot(shot: Shot){
        
        try! realm.write {
            realm.add(shot, update: true)
        }
    }
}