////
//  Item.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
