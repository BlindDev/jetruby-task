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
    
    init(withUser user: User) {
        self.userObject = user
    }
    
    var name: String! {
        return userObject.name
    }
    
    var avatarLink: String! {
        guard let link = userObject.avatar_url else{
            return ""
        }
        return link
    }
    
    var bio: String! {
        return userObject.bio.withoutHTML
    }
    
    func numberOfItems(segment: Int) -> Int {
        return 0
    }
}