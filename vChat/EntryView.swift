//
//  EntryView.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/27.
//

import SwiftUI
import SwiftData

struct EntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var deviceRecords: [VCDevice]
    
    @ViewBuilder
    var body: some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // iPhone
            iPhoneMainView()
        case .pad:
            // iPad
            Text("iPad")
        default:
            Text("Unavailable")
        }
    }
}

#Preview {
    EntryView()
        .modelContainer(for: [VCDevice.self, VCUser.self, VCFriend.self], inMemory: true)
}
