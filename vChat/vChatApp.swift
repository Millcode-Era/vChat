//
//  vChatApp.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import SwiftUI
import SwiftData
import SwCrypt

@main
struct vChatApp: App {
    @Environment(\.modelContext) private var modelContext
    @Query private var devices: [VCDevice]
    private var models: [any PersistentModel.Type] = [VCDevice.self, VCUser.self]
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if devices.count == 0 {
                        // generate key pair
                        do {
                            let (privateKey, publicKey) = try CC.RSA.generateKeyPair(4096)
                            let newDevice = VCDevice(publicKey: publicKey, privateKey: privateKey)
                            modelContext.insert(newDevice)
                        } catch {
                            print(error)
                        }
                    }
                }
        }
        .modelContainer(for: models)
    }
}
