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
    var senderImage: String?
    var date_:String
    var isMediaMessage_: Bool
    
    required init?(map: Map) {
        senderId_ = ""
        senderDisplayName_ = ""
        date_ = ""
        isMediaMessage_ = false
    }
    
    init(text:String, senderId:String, senderDisplayName:String, date:String, isMediaMessage:Bool, senderPhoto:String){
        self.text_ = text
        self.senderId_ = senderId
        self.senderDisplayName_ = senderDisplayName
        self.date_ = date
        self.isMediaMessage_ = isMediaMessage
        self.senderImage = senderPhoto
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
        senderImage <- map["senderImage"]
    }
}

// MARK: - JSQMessageData

extension ChatMessage{
    func senderId() -> String! {
        return senderId_
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_
    }
    
    func date() -> Date! {
        return Date.fromUTC(format: date_)
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
