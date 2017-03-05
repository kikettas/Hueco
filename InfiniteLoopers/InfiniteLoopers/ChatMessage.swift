//
//  ChatMessage.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/5/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import ObjectMapper

class ChatMessage:NSObject,JSQMessageData, Mappable{
    var text_:String?
    var senderId_: String
    var senderDisplayName_: String
    var date_:TimeInterval
    var isMediaMessage_: Bool
    
    required init?(map: Map) {
        senderId_ = ""
        senderDisplayName_ = ""
        date_ = 0
        isMediaMessage_ = false
    }
    
    init(text:String, senderId:String, senderDisplayName:String, date:TimeInterval, isMediaMessage:Bool){
        self.text_ = text
        self.senderId_ = senderId
        self.senderDisplayName_ = senderDisplayName
        self.date_ = date
        self.isMediaMessage_ = isMediaMessage
    }
    
    func senderId() -> String! {
        return senderId_
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_
    }
    
    func date() -> Date! {
        return Date(timeIntervalSinceNow: date_)
    }
    
    func isMediaMessage() -> Bool {
        return isMediaMessage_
    }
    
    func messageHash() -> UInt {
        return UInt(self.hashValue)
    }
    
    func text() -> String! {
        return text_
    }
}

// MARK: - Mappable

extension ChatMessage{
    func mapping(map: Map) {
        text_ <- map["text"]
        senderId_ <- map["senderId"]
        senderDisplayName_ <- map["senderDisplayName"]
        isMediaMessage_ <- map["isMediaMessage"]
        date_ <- map["date"]
    }
}
