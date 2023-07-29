//
//  iPhoneMainView.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/29.
//

import SwiftUI

struct iPhoneMainView: View {
    private enum MainViewPage: String {
        case chat, contact, me
    }
    
    @State private var selection: MainViewPage = .chat
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                iPhoneChatView()
                    .tag(MainViewPage.chat)
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
                Text("Contacts")
                    .tag(MainViewPage.contact)
                    .tabItem {
                        Label("Contact", systemImage: "person.crop.rectangle.stack")
                    }
                Text("Me")
                    .tag(MainViewPage.me)
                    .tabItem {
                        Label("Me", systemImage: "person.fill")
                    }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private var navigationTitle: LocalizedStringKey {
        switch selection {
        case .chat:
            return LocalizedStringKey("Chat")
        case .contact:
            return LocalizedStringKey("Contacts")
        case .me:
            return LocalizedStringKey("Me")
        }
    }
}

#Preview {
    iPhoneMainView()
        .modelContainer(for: [VCDevice.self, VCUser.self, VCFriend.self], inMemory: true)
}
