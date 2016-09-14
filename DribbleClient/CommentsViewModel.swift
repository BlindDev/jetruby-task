//
//  CommentsViewModel.swift
//  DribbleClient
//
//  Created by Pavel Popov on 14.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

class CommentsViewModel {
    
    private let dataManager = DataManager.sharedInstance
    private var shotID: Int
    
    init(withShotID id: Int){
        self.shotID = id
    }
    
    private var cellsModels: [CommentsTableViewCellViewModel]! {
        get{
            
            let comments = dataManager.savedComments(shotID)
            
            var commentViewModels: [CommentsTableViewCellViewModel] = []
            
            for comment in comments {
                let newModel = CommentsTableViewCellViewModel(withComment: comment)
                commentViewModels.append(newModel)
            }
            
            return commentViewModels
        }
    }
    
    func numberOfComments() -> Int {
        return cellsModels.count
    }
    
    func cellViewModel(atIndex index: Int) -> CommentsTableViewCellViewModel? {
        
        guard index < cellsModels.count else {
            return nil
        }
        
        return cellsModels[index]
    }
    
    func updateComments(completion: () -> ()) {
        
        dataManager.commentsAction(.GET, shotID: shotID, body: nil){
            completion()
        }
    }
    
    var commentAction:(comment: String, completion: VoidFunction)->(){
        get{
            return setComment
        }
    }
    
    private func setComment(body: String, completion: VoidFunction) {
        dataManager.commentsAction(.POST, shotID: shotID, body: body) {
            //TODO: add refreshing
            completion()
        }
    }
}