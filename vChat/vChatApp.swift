//
//  vChatApp.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import SwiftUI
import SwiftData

@main
struct vChatApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
