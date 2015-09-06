
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

func fetchMatches(callBack:([March]) -> ()){
    
    PFQuery(className: "Action")
    .whereKey("byUSer", equalTo: PFUser.currentUser()!.objectId!)
    .whereKey("type", equalTo: "matched")
        .findObjectsInBackgroundWithBlock(
        { (objects, error) -> Void in
        if let matches = objects as? [PFObject] {
            /*
            let matchedUsers = matches.map({
                (object)->(matchID:String, userID: String)
                in
                (object.objectId, object.objectForKey("toUser") as! String)
            })
        */
            /*
            var x :(matchID:String, userID: String)
            let matchedUsers:[x] = []
            for object in matches {
               
                //matchedUsers.append(newElement: (matchID: object.objectId!, userID: userID:object.objectForKey("toUser") as! String))
            
            }
            */
           // let userIDs = matchedUsers.map({$0.userID})
            /*
            PFUser.query()!
                .whereKey("objectId", containedIn: userIDs)
*/
        }
    })
    
}
