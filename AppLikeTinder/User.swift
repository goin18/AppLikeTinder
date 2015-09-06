//
//  User.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 31/08/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
}

func pfUserToUser(user:PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser(){
        return pfUserToUser(user)
    }
    return nil
}

func fatchUnviewedUsers(callback:([User]) -> ()) {
    
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        .findObjectsInBackgroundWithBlock({
        myObjects, error in
            if let obj = myObjects as? [PFObject]{
                let seenIDS = map(obj, {$0.objectForKey("toUser")!})

                PFUser.query()!
                    .whereKey("objectId",notEqualTo: PFUser.currentUser()!.objectId!)
                    .whereKey("objectId", notContainedIn: seenIDS)
                    .findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                        if let pfUsers = objects as? [PFUser]{
                            let users = map(pfUsers, {pfUserToUser($0)})
                            callback(users)
                        }
                }
            }
    })
}

func saveSkip(user: User){
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject("skipped", forKey: "type")
    skip.saveInBackground()    
}
/*
func saveLike(user: User){
    
    let like = PFObject(className: "Action")
    like.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
    like.setObject(user.id, forKey: "toUser")
    like.setObject("liked", forKey: "type")
    like.saveInBackground()

}
*/

func saveLike(user: User){
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: user.id)
        .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("type", equalTo: "liked")
        .getFirstObjectInBackgroundWithBlock({
            object,error in
            
            var matched = false
            if object != nil {
                matched = true
                object!.setObject("matched", forKey:"type")
                object!.saveInBackground()
            }
            
            let match = PFObject(className: "Action")
            match.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
            match.setObject(user.id, forKey: "toUser")
            match.setObject(matched ? "matched" : "liked" , forKey: "type")
            
            match.saveInBackground()
        })
    
    
}





