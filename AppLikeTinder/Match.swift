
//
//  Match.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 05/09/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation

struct Match {
    let id: String
    let user: User
}

func fetchMatches(callBack:([Match]) -> ()){
    
    PFQuery(className: "Action")
    .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
    .whereKey("type", equalTo: "matched")
        .findObjectsInBackgroundWithBlock({
            objects, error in
            if let matches = objects as? [PFObject] {
                
                let matchedUsers = matches.map({
                    (object)->(matchID: String, userID: String)
                    in
                    (object.objectId!, object.objectForKey("toUser") as! String)
                })
                
                println("matchedUsers: \(matchedUsers)")
                let userIDs = matchedUsers.map({$0.userID})
                
                PFUser.query()!
                .whereKey("objectId", containedIn: userIDs)
                .findObjectsInBackgroundWithBlock({
                    objects, error in
                    if let users = objects as? [PFUser] {
                        var users = reverse(users)
                        var m = Array<Match>()
                        for (index, user) in enumerate(users) {
                            m.append(Match(id: matchedUsers[index].matchID, user: pfUserToUser(user)))
                        }
                        callBack(m)
                    }
                    
                })
            }
    })
}
