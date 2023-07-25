//
//  ContentView.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var deviceRecords: [VCDevice]
    
    var body: some View {
        Form {
            Section("Debug Info") {
                // Get the first device record and display device's UUID
                Text(deviceRecords.first?.identifier.uuidString ?? "")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: VCDevice.self, inMemory: true)
}
