//
//  ConnectionManager.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import Alamofire

enum ShotLikeAction {
    case CHECK
    case LIKE
    case UNLIKE
}

class ConnectionManager {
    //GET https://api.dribbble.com/v1/user?access_token=...
    
    static let sharedInstance = ConnectionManager()
    
    private let clientID = "b2d5805b5067740cdb08b9c5f8678554aa46217f53a80fe77efb0646df48bc19"
    private let clientSecret = "faeea2937f32639cd3a25b6be70926246bbb0dea8edc4f4adfae43a4f16993c8"
    private let scope = "public+write+comment"
    private let mainLink = "https://api.dribbble.com/v1"
    private var token: String? {
        get{
            return DataManager.sharedInstance.savedToken()
        }
    }
    
    func fetchShots(completion:(savedShots: [Shot])->()) {
        
        guard let tokenString = token else{
            return
        }
        
        let link = mainLink + "/shots"
        
        let parameters = [
            "per_page" : "100",
            "access_token" : tokenString
        ]
        
        startConnection(withMethod: .GET, link:link, parameters: parameters) { (result) in
            
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let shots = serializer.responseShots()
                
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateShots(shots)
                
                completion(savedShots: dataManager.savedShots())
            }
        }
    }
    
    private let shotLikeActionDictionary: [ShotLikeAction : Alamofire.Method] = [
        .CHECK    : .GET,
        .LIKE   : .POST,
        .UNLIKE : .DELETE
    ]
    
    func shotLikeAction(action: ShotLikeAction, shotID: Int, completion:() ->()) {
        guard let tokenString = token else{
            return
        }
        
        guard let method = shotLikeActionDictionary[action] else{
            return
        }
        
        let link = mainLink + "/shots/\(shotID)/like"
        
        let parameters = [
            "access_token" : tokenString
        ]
        
        startConnection(withMethod: method, link:link, parameters: parameters) { (result) in
            
            if  let currentResult = result {
                
                let serializer = Serializer(responseValue: currentResult)
                
                let dataManager = DataManager.sharedInstance
                
                dataManager.updateShotLikeByID(shotID, liked: serializer.responseShotHasLikeDate())
                
                completion()
            }
        }
    }
    
    func getUserInfo() {
        
    }
    
    func getShotComments(id: String) {
        //GET /shots/:shot/comments
    }
    
    func createComment() {
        //POST /shots/:shot/comments
    }
    
//    Like a shot
//    POST /shots/:id/like
    
    var loginURL: NSURL? {
        get{
            let authLink = "https://dribbble.com/oauth/authorize?client_id=\(clientID)&scope=\(scope)&state=JetRuby_STATE"

            if let authURL = NSURL(string: authLink) {
                return authURL
            }
            return nil
        }
    }
    
    func processFirstStepResponse(responseURL: NSURL) {
        
        let components = NSURLComponents(URL: responseURL, resolvingAgainstBaseURL: false)
        
        var code:String?
        
        if let queryItems = components?.queryItems{
            for queryItem in queryItems{
                if (queryItem.name.lowercaseString == "code"){
                    code = queryItem.value
                    break
                }
            }
        }
        
        if let receivedCode = code {
            
            let tokenLink = "https://dribbble.com/oauth/token"
            
            let tokenParameters = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": receivedCode
            ]
                        
            startConnection(withMethod: .POST, link: tokenLink, parameters: tokenParameters) { (result) in
               
                if let value = result {
                    let serializer = Serializer(responseValue: value)
                    
                    let token = serializer.responseAuthToken()
                    let dataManager = DataManager.sharedInstance

                    dataManager.updateToken(token)
                }
            }
        }
    }
    
    private func startConnection(withMethod method: Alamofire.Method, link: String, parameters: [String: String], completion: (result: AnyObject?)->()) {
        
        Alamofire.request(method, link, parameters: parameters)
            .responseJSON { response in
                                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        completion(result: value)
                    }
                    
                case .Failure(let error):
                    print(error)
                    completion(result: nil)
                }
        }
    }
}