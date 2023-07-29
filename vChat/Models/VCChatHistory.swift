//
//  VCChatHistory.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/29.
//

import Foundation
import SwiftData

@Model
class VCChatHistory {
    var content: Data
    var type: ChatHistoryType
    @Relationship(.nullify) var withFriend: VCFriend?
    var isReceive: Bool
    var date: Date
    
    init(content: Data, type: ChatHistoryType, withFriend: VCFriend? = nil, isReceive: Bool, date: Date = Date.now) {
        self.content = content
        self.type = type
        self.withFriend = withFriend
        self.isReceive = isReceive
        self.date = date
    }
    
    init(text: String, type: ChatHistoryType, withFriend: VCFriend? = nil, isReceive: Bool, date: Date = Date.now) {
        self.content = text.data(using: .utf8)!
        self.type = type
        self.withFriend = withFriend
        self.isReceive = isReceive
        self.date = date
    }
}

enum ChatHistoryType: String {
    case text, image, audio
}
