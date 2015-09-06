//
//  ChatViewCcontroller.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 06/09/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation

class ChatViewController: JSQMessagesViewController {

    var messagess: [JSQMessage] = []
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incomingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = currentUser()!.id
        self.senderDisplayName = currentUser()!.id
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    /*
    func sendersDisplayName() -> String! {
        return currentUser()!.id
    }
    
    func senderId() -> String! {
        return currentUser()!.id
    }
    */
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.messagess[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagess.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        var data = self.messagess[indexPath.row]
        
        if data.senderId == PFUser.currentUser()?.objectId! {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let m = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messagess.append(m)
        finishSendingMessage()
    }
    
    
}
