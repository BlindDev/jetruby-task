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
    
    private var listSegment = 0
    
    private var cellsModels: [ListCellModel]! {
        
        let dataManager = DataManager.sharedInstance
        
        var cellModels: [ListCellModel] = []

        if listSegment == 0 {
            let followers = dataManager.savedFollowersForUser(userObject.id)
            
            for follower in followers {
                let newModel = ListCellModel(withFollower: follower)
                cellModels.append(newModel)
            }            
        }else{
            let likes = dataManager.savedLikesForUser(userObject.id)
            
            for like in likes {
                let newModel = ListCellModel(withLike: like)
                cellModels.append(newModel)
            }
        }

        return cellModels

    }
    
    func cellViewModel(atIndex index: Int) -> ListCellModel? {
        
        guard index < cellsModels.count else {
            return nil
        }
        
        return cellsModels[index]
    }
    
    func numberOfItems(segment: Int) -> Int {
        listSegment = segment
        
        return cellsModels.count
    }
    
    func updateValuesForSegment(segment: Int, completion: () -> ()) {
        
        let dataManager = DataManager.sharedInstance

        if segment == 0 {
            dataManager.fetchFollowersForUser(userObject.id){
                completion()
            }
        }else{
            dataManager.fetchLikesForUser(userObject.id){
                completion()
            }
        }
    }
}