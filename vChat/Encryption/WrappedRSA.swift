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
    static func generateKeyPair(_ keySize: Int = 4096) throws -> (RSAPrivateKey, RSAPublicKey) {
        let (priKey, pubKey) = try CC.RSA.generateKeyPair(keySize)
        return (RSAPrivateKey(fromDER: priKey), RSAPublicKey(fromDER: pubKey))
    }
    
    /// Encrypt a `RSARawValue`
    /// - Parameters:
    ///   - data: `RSARawValue` that should encrypt
    ///   - publicKey: RSA Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Encrypted value
    static fileprivate func encrypt(
        data: RSARawValue,
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSAEncryptedValue {
        let encrypted = try CC.RSA.encrypt(data.rawValue, derKey: publicKey.rawValue, tag: Data(), padding: padding, digest: digest)
        return RSAEncryptedValue(encrypted)
    }
    
    /// Decrypt a `RSAEncryptedValue`
    /// - Parameters:
    ///   - data: `RSAEncryptedValue` that should decrypt
    ///   - privateKey: RSA Private Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Decrypted value
    static fileprivate func decrypt(
        data: RSAEncryptedValue,
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSARawValue {
        let decrypt = try CC.RSA.decrypt(data.rawValue, derKey: privateKey.rawValue, tag: Data(), padding: padding, digest: digest)
        return RSARawValue(decrypt.0)
    }
    
    /// Sign a message
    /// - Parameters:
    ///   - message: A `RSARawValue`, the message that you need to sign
    ///   - privateKey: Private key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Signed Message
    static fileprivate func sign(
        message: RSARawValue,
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricSAPadding = .pkcs15,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> RSASignature {
        let signed = try CC.RSA.sign(message.rawValue, derKey: privateKey.rawValue, padding: padding, digest: digest, saltLen: saltLength)
        return RSASignature(signed)
    }
    
    /// Verify a original message
    /// - Parameters:
    ///   - message: Original message that
    ///   - signature: Signed message
    ///   - publicKey: Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Verify result. `true` for succes, `false` for false
    static fileprivate func verify(
        message: RSARawValue,
        signature: RSASignature,
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricSAPadding = .pkcs15,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> Bool {
        return try CC.RSA.verify(message.rawValue, derKey: publicKey.rawValue, padding: padding, digest: digest, saltLen: saltLength, signedData: signature.rawValue)
    }
}

/// RSA Private Key
struct RSAPrivateKey {
    private var data: Data
    
    /// Generate a RSA Private Key from DER `Data`
    /// - Parameter data: DER Data
    init(fromDER data: Data) {
        self.data = data
    }
    
    /// Generate a RSA Private Key from PCKS1 string
    /// - Parameter pcks1Key: PCKS1 String
    init(fromPKCS1 pcks1Key: String) throws {
        self.data = try SwCrypt.SwKeyConvert.PrivateKey.pemToPKCS1DER(pcks1Key)
    }
    
    /// Generate a RSA Private Key from encrypted PEM string
    /// - Parameters:
    ///   - encryptedKey: Encrypted PEM string
    ///   - password: Key password
    init(_ encryptedKey: String, password: String) throws {
        let decryptedPEMKey = try SwCrypt.SwKeyConvert.PrivateKey.decryptPEM(encryptedKey, passphrase: password)
        self = try Self.init(fromPKCS1: decryptedPEMKey)
    }
    
    init?(base64Encoded: String) {
        if let data = Data(base64Encoded: base64Encoded) {
            self.data = data
        } else {
            return nil
        }
    }
}
extension RSAPrivateKey {
    /// Get raw `Data` of this key
    fileprivate var rawValue: Data {
        data
    }
    
    /// Export key to DER format
    /// - Returns: DER Data
    func toDER() -> Data {
        rawValue
    }
    
    /// Export key to PEM PKCS1 format
    /// - Returns: PKCS1 String
    func toPCKS1() -> String {
        SwCrypt.SwKeyConvert.PrivateKey.derToPKCS1PEM(rawValue)
    }
    
    /// Export key to encrypted PEM format
    /// - Parameters:
    ///   - password: Key password
    ///   - aesMode: AES encryption mode
    /// - Returns: Encrypted PEM key
    func encryptedKey(_ password: String, aesMode: SwKeyConvert.PrivateKey.EncMode = .aes256CBC) throws -> String {
        try SwCrypt.SwKeyConvert.PrivateKey.encryptPEM(self.toPCKS1(), passphrase: password, mode: aesMode)
    }
}

/// RSA Public Key
struct RSAPublicKey {
    private var data: Data
    
    /// Generate a RSA Public Key from DER `Data`
    /// - Parameter data: DER Data
    init(fromDER data: Data) {
        self.data = data
    }
    
    /// Generate a RSA Public Key from PCKS1 string
    /// - Parameter pcks1Key: PCKS1 String
    init(fromPKCS1 pcks1Key: String) throws {
        self.data = try SwCrypt.SwKeyConvert.PublicKey.pemToPKCS1DER(pcks1Key)
    }
    
    /// Generate a RSA Public Key from PCKS8 string
    /// - Parameter pcks8Key: PCKS8 String
    init(fromPKCS8 pcks8Key: String) throws {
        self.data = try SwCrypt.SwKeyConvert.PublicKey.pemToPKCS8DER(pcks8Key)
    }
    
    init?(base64Encoded: String) {
        if let data = Data(base64Encoded: base64Encoded) {
            self.data = data
        } else {
            return nil
        }
    }
}
extension RSAPublicKey {
    /// Get raw `Data` of this key
    fileprivate var rawValue: Data {
        data
    }
    
    /// Export key to DER format
    /// - Returns: DER Data
    func toDER() -> Data {
        rawValue
    }
    
    /// Export key to PEM PKCS1 format
    /// - Returns: PKCS1 String
    func toPCKS1() -> String {
        SwCrypt.SwKeyConvert.PublicKey.derToPKCS1PEM(rawValue)
    }
    
    /// Export key to PEM PKCS8 format
    /// - Returns: PKCS8 String
    func toPCKS8() -> String {
        SwCrypt.SwKeyConvert.PublicKey.derToPKCS8PEM(rawValue)
    }
}

/// RSA Raw Value
struct RSARawValue {
    private var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    init(_ string: String) {
        self.data = string.data(using: .utf8)!
    }
}
extension RSARawValue {
    var rawValue: Data {
        data
    }
    
    var toString: String? {
        String(data: rawValue, encoding: .utf8)
    }
    
    var toData: Data {
        rawValue
    }
    
    /// Encrypt
    /// - Parameters:
    ///   - publicKey: RSA Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Encrypted value
    func encrypt(
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSAEncryptedValue {
        try RSA.encrypt(data: self, publicKey: publicKey, padding: padding, digest: digest)
    }
    
    /// Sign
    /// - Parameters:
    ///   - privateKey: Private key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Signed Message
    func sign(
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricSAPadding = .pkcs15,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> RSASignature {
        try RSA.sign(message: self, privateKey: privateKey, padding: padding, digest: digest, saltLength: saltLength)
    }
    
    /// Verify
    /// - Parameters:
    ///   - signature: Signed message
    ///   - publicKey: Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Verify result. `true` for succes, `false` for false
    func verify(
        signature: RSASignature,
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricSAPadding = .pkcs15,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> Bool {
        try RSA.verify(message: self, signature: signature, publicKey: publicKey, padding: padding, digest: digest, saltLength: saltLength)
    }
}

/// Encrypted RSA Raw Value
struct RSAEncryptedValue {
    private var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    /// Generate RSA excrypted value from Base-64 encoded string
    /// - Parameters:
    ///   - base64Encoded: Base-64 encoded string
    ///   - options: The options to use for the decoding. Default value is [].
    init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        if let data = Data(base64Encoded: base64Encoded, options: options) {
            self.data = data
        } else {
            return nil
        }
    }
}
extension RSAEncryptedValue {
    var rawValue: Data {
        data
    }
    
    /// Return a Base-64 Encoded RSA encrypted value
    /// - Parameter options: The options to use for the encoding. Default value is [].
    /// - Returns: Base-64 encoded RSA encrypted value
    func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        rawValue.base64EncodedString(options: options)
    }
    
    /// Decrypt
    /// - Parameters:
    ///   - privateKey: RSA Private Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Decrypted value
    func decrypt(
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSARawValue {
        try RSA.decrypt(data: self, privateKey: privateKey, padding: padding, digest: digest)
    }
}

struct RSASignature {
    private var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    /// Generate RSA signature value from Base-64 encoded string
    /// - Parameters:
    ///   - base64Encoded: Base-64 encoded string
    ///   - options: The options to use for the decoding. Default value is [].
    init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        if let data = Data(base64Encoded: base64Encoded, options: options) {
            self.data = data
        } else {
            return nil
        }
    }
}
extension RSASignature {
    var rawValue: Data {
        data
    }
    
    /// Return a Base-64 Encoded RSA signature value
    /// - Parameter options: The options to use for the encoding. Default value is [].
    /// - Returns: Base-64 encoded RSA signature value
    func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        rawValue.base64EncodedString(options: options)
    }
}
