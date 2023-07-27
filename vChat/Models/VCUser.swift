//
//  VCUser.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/27.
//

import Foundation
import SwiftData

@Model
/// The model that stored local user
class VCUser {
    @Attribute(.unique) var uid: String
    var username: String
    var password: String
    
    // TODO: Bind to VCFriend
    // The binding should have a cascade relationship to VCFriend
    /// User's friends
    var friendList: [String]
    
    /// Create a new `User` which stored locally.
    /// - Parameters:
    ///   - uid: User's identifier
    ///   - username: User's name that defined by it own
    ///   - password: SHA256 digested password
    init(uid: String, username: String, password: String) {
        self.uid = uid
        self.username = username
        self.password = password
    }
}
