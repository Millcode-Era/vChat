//
//  vChatApp.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import SwiftUI
import SwiftData
import Observation

@main
struct vChatApp: App {
    @State private var errorView = ErrorViewController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(errorView)
                .overlay {
                    if errorView.isErrorViewPresent {
                        ErrorView(errorArea: errorView.errorArea, error: errorView.error)
                    }
                }
        }
        .modelContainer(for: [VCDevice.self, VCUser.self, VCFriend.self, VCChatHistory.self])
    }
}

@Observable
class ErrorViewController {
    var error: Error?
    var errorArea: String?
    var isErrorViewPresent = false
    
    func showError(_ errorArea: String, error: Error) {
        self.error = error
        self.errorArea = errorArea
        self.isErrorViewPresent = true
    }
}
