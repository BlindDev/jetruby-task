//
//  CommentsTableViewCellViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class CommentsTableViewCellViewModel {
    
    private var comment: Comment
    
    init(withComment comment: Comment){
        self.comment = comment        
    }
    
    var commentBody: String! {
        get{
            return comment.body.withoutHTML
        }
    }
    
    var date: String! {
        get{
            
            guard let dateString = comment.created?.convertedString else{
                return ""
            }
            
            return dateString
        }
    }
    
    var userName: String! {
        get{
            guard let user = comment.user?.username else{
                return ""
            }
            
            return user
        }
    }
    
    var avatarLink: String! {
        get{
            guard let link = comment.user?.avatar_url else{
                return ""
            }
            return link
        }
    }
}
