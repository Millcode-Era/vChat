//
//  WrappedRSA.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/27.
//

import Foundation
import SwCrypt

/// RSA Asymmetric Encryption
/// Encapsulated from SwCrypt
final class RSA {
    /// Generate a key pair
    /// - Parameter keySize: Key size, default as `4096`
    /// - Returns: private key and public key (in order)
    func generateKeyPair(_ keySize: Int = 4096) throws -> (RSAPrivateKey, RSAPublicKey) {
        let (priKey, pubKey) = try CC.RSA.generateKeyPair(keySize)
        return (RSAPrivateKey(data: priKey), RSAPublicKey(data: pubKey))
    }
}

struct RSAPrivateKey {
    private var data: Data
    
    init(data: Data) {
        self.data = data
    }
}

struct RSAPublicKey {
    private var data: Data
    
    init(data: Data) {
        self.data = data
    }
}
