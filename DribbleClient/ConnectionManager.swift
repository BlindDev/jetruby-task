//
//  ConnectionManager.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPMehod {
    case GET
    case POST
    case DELETE
}

class ConnectionManager {
    //GET https://api.dribbble.com/v1/user?access_token=...
        
    private let clientID = "b2d5805b5067740cdb08b9c5f8678554aa46217f53a80fe77efb0646df48bc19"
    private let clientSecret = "faeea2937f32639cd3a25b6be70926246bbb0dea8edc4f4adfae43a4f16993c8"
    private let scope = "public+write+comment"
    private let mainLink = "https://api.dribbble.com/v1"
    private var token: String?
    
    typealias ResponseResultFunction = (result: AnyObject?) -> ()
    
    init(withSavedToken token: String?) {
        self.token = token
    }
    
    func setNewToken(newToken: String?)  {
        token = newToken
    }
    
    func fetchShots(page: String, completion:ResponseResultFunction) {
        
        guard let tokenString = token else{
            return
        }
        
        let link = mainLink + "/shots"
        
        let parameters = [
            "page" : page,
            "per_page" : "100",
            "access_token" : tokenString
        ]
        
        startConnection(withMethod: .GET, link:link, parameters: parameters) { (result) in
            
            completion(result: result)
        }
    }
    
    private let httpMethodsDictionary: [HTTPMehod : Alamofire.Method] = [
        .GET    : .GET,
        .POST   : .POST,
        .DELETE : .DELETE
    ]
    
    func shotLikeAction(action: HTTPMehod, shotID: Int, completion:ResponseResultFunction) {
       
        guard let tokenString = token else{
            return
        }
        
        guard let method = httpMethodsDictionary[action] else{
            return
        }
        
        let link = mainLink + "/shots/\(shotID)/like"
        
        let parameters = [
            "access_token" : tokenString
        ]
        
        startConnection(withMethod: method, link:link, parameters: parameters) { (result) in
            
            completion(result: result)
        }
    }
    
    func shotCommentAction(action: HTTPMehod, shotID: Int, body: String?, completion:ResponseResultFunction) {

        guard let tokenString = token else{
            return
        }
        
        guard let method = httpMethodsDictionary[action] else{
            return
        }
        
        let link = mainLink + "/shots/\(shotID)/comments"
        
        var parameters = [
            "access_token" : tokenString
        ]
        
        if let comment = body {
            parameters["body"] = "<p>\(comment)</p>"
        }
        
        print(parameters)
        
        startConnection(withMethod: method, link:link, parameters: parameters) { (result) in
            
            completion(result: result)
        }
    }
    
    func fetchFollowersForUser(userID: Int, page: String, completion:ResponseResultFunction) {
        
        guard let tokenString = token else{
            return
        }
        
        let link = mainLink + "/users/\(userID)/followers"
        
        let parameters = [
            "page" : page,
            "per_page" : "100",
            "access_token" : tokenString
        ]
        
        startConnection(withMethod: .GET, link:link, parameters: parameters) { (result) in
            
            completion(result: result)
        }
    }
    
    func fetchLikesForUser(userID: Int, page: String, completion:ResponseResultFunction) {
        
        guard let tokenString = token else{
            return
        }
        
        let link = mainLink + "/users/\(userID)/likes"
        
        let parameters = [
            "page" : page,
            "per_page" : "100",
            "access_token" : tokenString
        ]
        
        startConnection(withMethod: .GET, link:link, parameters: parameters) { (result) in
            
            completion(result: result)
        }
    }
    
    var loginURL: NSURL? {
        get{
            let authLink = "https://dribbble.com/oauth/authorize?client_id=\(clientID)&scope=\(scope)&state=JetRuby_STATE"

            if let authURL = NSURL(string: authLink) {
                return authURL
            }
            return nil
        }
    }
    
    func processFirstStepResponseURL(responseURL: NSURL, completion: ResponseResultFunction) {
        
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
               
                completion(result: result)
            }
        }
    }
    
    private func startConnection(withMethod method: Alamofire.Method, link: String, parameters: [String: String], completion: ResponseResultFunction) {
        
        Alamofire.request(method, link, parameters: parameters)
            .responseJSON { response in
                
                print("Answwer \(response.response) \n Request \(response.request) \n ===================")
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