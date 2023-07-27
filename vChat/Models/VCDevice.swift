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
    // stored at Base64 because SwiftData cannot stored correctly
    var publicKey: String
    var privateKey: String
    
    /// Create a new `VCDevice` record to represent the local device.
    /// Only read the first VCDevice record in `@Query` request.
    /// - Parameters:
    ///   - publicKey: RSA public key.
    ///   - privateKey: RSA private key.
    init(publicKey: String, privateKey: String) {
        self.identifier = UUID()
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    init(publicKey: RSAPublicKey, privateKey: RSAPrivateKey) {
        self.identifier = UUID()
        self.publicKey = publicKey.toDER().base64EncodedString()
        self.privateKey = privateKey.toDER().base64EncodedString()
    }
}

extension VCDevice {
    func getPrivateKey() -> RSAPrivateKey? {
        RSAPrivateKey(base64Encoded: self.privateKey)
    }
    func getPublicKey() -> RSAPublicKey? {
        RSAPublicKey(base64Encoded: self.publicKey)
    }
    
    func setPrivateKey(_ privateKey: RSAPrivateKey) {
        self.privateKey = privateKey.toDER().base64EncodedString()
    }
    func setPublicKey(_ publicKey: RSAPublicKey) {
        self.publicKey = publicKey.toDER().base64EncodedString()
    }
}
