//
//  ContentView.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import SwiftUI
import SwiftData
import SwCrypt

struct ContentView: View {
    @Environment(ErrorViewController.self) private var errorView
    @Environment(\.modelContext) private var modelContext
    @Query private var devices: [VCDevice]
    var body: some View {
        EntryView()
            .onAppear {
                if devices.count == 0 {
                    // generate key pair
                    do {
                        let (privateKey, publicKey) = try CC.RSA.generateKeyPair(4096)
                        let newDevice = VCDevice(publicKey: publicKey.base64EncodedString(), privateKey: privateKey.base64EncodedString())
                        modelContext.insert(newDevice)
                    } catch {
//                            print(error)
                        errorView.showError("Application.Initializer", error: error)
                    }
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [VCDevice.self, VCUser.self])
        .environment(ErrorViewController())
}
