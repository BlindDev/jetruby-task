//
//  ConnectionManager.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionManager {
    //GET https://api.dribbble.com/v1/user?access_token=...
    
    static let sharedInstance = ConnectionManager()
    
    private let clientID = "b2d5805b5067740cdb08b9c5f8678554aa46217f53a80fe77efb0646df48bc19"
    private let clientSecret = "faeea2937f32639cd3a25b6be70926246bbb0dea8edc4f4adfae43a4f16993c8"
    private let scope = "public+write+comment"
    private let mainLink = "https://api.dribbble.com/v1"
    
    func fetchShots(token: String, completion:()->()) {
        
        let link = mainLink + "/shots"

        let parameters = [
            "per_page" : "100",
            "access_token" : token
        ]
        
        getConnection(link, parameters: parameters) { (result) in
            
            let serializer = Serializer(responseValue: result)
            
            let shots = serializer.responseShots()
            
            let dataManager = DataManager.sharedInstance

            dataManager.updateShots(shots)

            completion()
        }
    }
    
    func getUserInfo(withToken token: String) {
        
    }
    
    func getShotComments(id: String) {
        //GET /shots/:shot/comments
    }
    
    func createComment() {
        //POST /shots/:shot/comments
        
    }
    
    func getConnection(link: String, parameters: [String: String], completion: (result: AnyObject)->()) {
        
        Alamofire.request(.GET, link, parameters: parameters)
            .responseJSON { response in
                
//                print("Response: \(response.request)")
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        
                        completion(result: value)
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    func postConnection(link: String, parameters: [String: String], completion: (result: AnyObject?)->()){
        
        Alamofire.request(.POST, link, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .Success:
//                    print(response.result.value)
                    completion(result: response.result.value)
                case .Failure(let error):
                    print(error)
                }
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
            
            
            postConnection(tokenLink, parameters: tokenParameters) { (result) in
               
                if let value = result {
                    let serializer = Serializer(responseValue: value)
                    
                    let token = serializer.responseAuthToken()
                    let dataManager = DataManager.sharedInstance

                    dataManager.updateToken(token)
                }
//                else{
//                    dataManager.updateToken(nil)
//                }

            }
        }
    }
}