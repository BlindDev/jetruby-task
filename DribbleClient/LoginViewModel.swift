//
//  LoginViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 09.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    private var url: NSURL?
    
    init(withAuthURL  url: NSURL?) {
        self.url = url
    }
    
    var authURL: NSURL? {
        return url
    }
}

