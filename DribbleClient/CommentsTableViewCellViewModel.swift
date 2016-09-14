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
    
    var commentBody: String{
        get{
            return comment.body
        }
    }
}
