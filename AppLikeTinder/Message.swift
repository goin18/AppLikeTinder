//
//  Message.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 06/09/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let senderID:String
    let date: NSDate
    
}

class MessageListener {
    var currentHandler: UInt?
    
    init(matchID: String, startDate: NSDate, callback:(Message) -> ()){
        let handle = ref.childByAppendingPath(matchID)
            .queryOrderedByKey()
            .queryStartingAtValue(dateFormatter().stringFromDate(startDate))
            .observeEventType(FEventType.ChildAdded, withBlock: {
                snapshot in
                    let message = snapshotToMessage(snapshot)
                    callback(message)
        })
        self.currentHandler = handle
    }
    
    func stop(){
        if let handle = currentHandler {
            ref.removeObserverWithHandle(handle)
            currentHandler = nil
        }
    }
}

private let ref = Firebase(url: "https://appliketinder.firebaseio.com/messages")
private let dateFormat = "yyyyMMddHHmmss"

private func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}

func saveMessage(matchID: String, message:Message) {
    ref.childByAppendingPath(matchID)
        .updateChildValues([dateFormatter().stringFromDate(message.date) : ["message": message.message, "sender":message.senderID]])
}

private func snapshotToMessage(snapshote:FDataSnapshot) -> Message {
    let date = dateFormatter().dateFromString(snapshote.key)
    let sender = snapshote.value["sender"] as? String
    let text = snapshote.value["message"] as? String
    return Message(message: text!, senderID: sender!, date: date!)
}

func fatchMessage(matchID: String, callback: ([Message]) -> ()) {
    ref.childByAppendingPath(matchID).queryLimitedToFirst(10).observeSingleEventOfType(FEventType.Value, withBlock: {
        (snapshot) -> Void in
        var messages:[Message] = []
        let enumerator = snapshot.children
        
        while let data = enumerator!.nextObject() as? FDataSnapshot {
            messages.append(snapshotToMessage(data))
        }
        callback(messages)
    })
}
