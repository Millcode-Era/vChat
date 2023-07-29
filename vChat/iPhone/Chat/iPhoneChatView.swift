//
//  iPhoneChatView.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/29.
//

import SwiftUI
import SwiftData

struct iPhoneChatView: View {
    @Query private var friends: [VCFriend]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List(friends) { friend in
            NavigationLink {
                
            } label: {
                Text(friend.nickname ?? friend.username)
            }
        }
        #if DEBUG
        .onTapGesture(count: 3) {
            let uid = Int.random(in: 100000...999999)
            let newFriend = VCFriend(uid: String(uid), username: "New Debug Friend \(uid)")
            withAnimation {
                modelContext.insert(newFriend)
            }
        }
        #endif
    }
}

#Preview {
    iPhoneChatView()
        .modelContainer(for: [VCDevice.self, VCUser.self, VCFriend.self], inMemory: true)
}
