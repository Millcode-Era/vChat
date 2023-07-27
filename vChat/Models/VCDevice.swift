//
//  VCDevice.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/26.
//

import Foundation
import SwiftData

@Model
/// The model that stored device settings.
class VCDevice {
    // The identifier represent the device, it not should to changed
    var identifier: UUID
    
    // Those are key that stored locally
    var publicKey: Data
    var privateKey: Data
    
    /// Create a new `VCDevice` record to represent the local device.
    /// Only read the first VCDevice record in `@Query` request.
    /// - Parameters:
    ///   - publicKey: RSA public key.
    ///   - privateKey: RSA private key.
    init(publicKey: Data, privateKey: Data) {
        self.identifier = UUID()
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
