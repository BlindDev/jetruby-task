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
}