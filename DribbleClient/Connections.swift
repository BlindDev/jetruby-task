//
//  Connections.swift
//  DribbleClient
//
//  Created by Pavel Popov on 08.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConnectionsManager {
    //YYYY-MM-DDTHH:MM:SSZ
    //GET https://api.dribbble.com/v1/user?access_token=...
    
    static let sharedInstance = ConnectionsManager()
    
    private let clientID = "b2d5805b5067740cdb08b9c5f8678554aa46217f53a80fe77efb0646df48bc19"
    private let clientSecret = "faeea2937f32639cd3a25b6be70926246bbb0dea8edc4f4adfae43a4f16993c8"
    private let scope = "comment"
    private let mainLink = "https://api.dribbble.com/v1"
    
    private var accessToken: String? {
        didSet{
            //TODO: add realm saving to database
        }
    }
    
    func hasToken() -> Bool {
        
        if let token = self.accessToken{
            return !token.isEmpty
        }
        return false
    }
    
    func fetchShots() {
        
        let link = mainLink + "/shots"
        
        let parameters = [
            "list" : "attachments"
        ]
    }
    
    func startLogin() {
        
        let authLink = "https://dribbble.com/oauth/authorize?client_id=\(clientID)&scope=\(scope)&state=JetRuby_STATE"
       
        if let authURL = NSURL(string: authLink) {
            UIApplication.sharedApplication().openURL(authURL)
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
            
            Alamofire.request(.POST, tokenLink, parameters: tokenParameters)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
//                            print("JSON: \(json)")

                            self.updateToken(withJSON: json)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    private func updateToken(withJSON json: JSON) {
        
        guard let accessString = json["access_token"].string else{
            return
        }
        
        accessToken = accessString
    }
}