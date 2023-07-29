//
//  VCFriend.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/28.
//

import Foundation
import SwiftData

@Model
class VCFriend {
    @Attribute(.unique) var uid: String
    var username: String
    var nickname: String?
    
    var keys: [UUID: String] = [:]
    
    init(uid: String, username: String, nickname: String? = nil) {
        self.uid = uid
        self.username = username
        self.nickname = nickname
        self.keys = [:]
    }
}
