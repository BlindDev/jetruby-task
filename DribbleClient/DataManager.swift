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

class DataManager {
    static let sharedInstance = DataManager()
    
    func savedToken() -> String? {
        
        let realm = try! Realm()
        
        if let token = realm.objects(Token).first {
            return token.accessToken
        }
        return nil
    }
    
    func updateToken(token: String?) {
        
        let realm = try! Realm()
        
        guard let newToken = token else{
            return
        }
        
        if let token = realm.objects(Token).first {
            try! realm.write {
                token.accessToken = newToken
            }
        }
    }
}