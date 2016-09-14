//
//  UserViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 15.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class UserViewModel {
    private var userObject: User
    
    init(withUser user: User){
        self.userObject = user
    }
    
    var name: String!{
        get{
            return userObject.name
        }
    }
}