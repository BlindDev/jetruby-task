//
//  Connections.swift
//  DribbleClient
//
//  Created by Pavel Popov on 08.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionsManager {
    //YYYY-MM-DDTHH:MM:SSZ
    
    static let sharedInstance = ConnectionsManager()
    
    private let clientID = "b2d5805b5067740cdb08b9c5f8678554aa46217f53a80fe77efb0646df48bc19"
    private let clientSecret = "faeea2937f32639cd3a25b6be70926246bbb0dea8edc4f4adfae43a4f16993c8"
    private let clientToken = "c65a495d3b3104de65239e29bb492c8e8fb232355be72868a7d0404b138bc93a"
    private let scope = "comment"
    //GET https://api.dribbble.com/v1/user?access_token=...
    //https://dribbble.com/oauth/authorize
    private let mainLink = "https://api.dribbble.com/v1"
    
    func fetchShots() {
        
        let link = mainLink + "/shots"
        
        let parameters = [
            "list" : "attachments"
        ]
    }
    
    func startLogin() {
        
        let authPath:String = "https://dribbble.com/oauth/authorize?client_id=\(clientID)&scope=\(scope)&state=TEST_STATE"
       
        if let authURL = NSURL(string: authPath) {
            UIApplication.sharedApplication().openURL(authURL)
        }
    }
}