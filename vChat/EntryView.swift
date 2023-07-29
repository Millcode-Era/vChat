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
    
    var body: some View {
        Form {
            Section("Debug Info") {
                // Get the first device record and display device's UUID
                Text(deviceRecords.first?.identifier.uuidString ?? "")
            }
            Section("Key pair") {
                ScrollView(.horizontal) {
                    Text(deviceRecords.first?.getPublicKey.toPCKS1() ?? "nil")
                        .fontDesign(.monospaced)
                }
                ScrollView(.horizontal) {
                    Text(deviceRecords.first?.getPrivateKey.toPCKS1() ?? "nil")
                        .fontDesign(.monospaced)
                }
            }
        }
    }
}

#Preview {
    EntryView()
        .modelContainer(for: [VCDevice.self, VCUser.self, VCFriend.self], inMemory: true)
}
