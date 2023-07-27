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
    @Environment(\.modelContext) private var modelContext
    @Query private var devices: [VCDevice]
    private var models: [any PersistentModel.Type] = [VCDevice.self, VCUser.self]
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // application launched at first time
                    // The keys and not linked yet
                    // TODO: Link generated keypairs to the VCDevice
                    if devices.count == 0 {
                        let newDevice = VCDevice(publicKey: Data(), privateKey: Data())
                        modelContext.insert(newDevice)
                    }
                }
        }
        .modelContainer(for: models)
    }
}
