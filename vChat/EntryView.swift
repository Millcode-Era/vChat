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
                Text(deviceRecords.first?.publicKey ?? "")
                Text(deviceRecords.first?.privateKey ?? "")
            }
        }
    }
}

#Preview {
    EntryView()
        .modelContainer(for: VCDevice.self, inMemory: true)
}
